export
   quantum_search,
   maximize_quantum_search,
   all_quantum_search,
   all_measured_quantum_search


function evolve(qss::QSearch, state::QSearchState)
   evolve(qss, state.state)
end

function expected_runtime(runtime::T,
                          probability::S) where {T<:Real, S<:Real}
   if runtime == 0
      Inf
   else
      runtime/probability
   end
end

function expected_runtime(state::QSearchState)
   expected_runtime(state.time, state.probability)
end

function all_quantum_search(qss::QSearch{T} where T<:DiscrQWalk,
                            runtime::Int)
   @assert runtime >= 0 "Time needs to be nonnegative"

   result = QSearchState[]
   push!(result, QSearchState(qss, initial_state(qss), 0))

   for t=1:runtime
      push!(result, QSearchState(qss, evolve(qss, result[end]), t))
   end

   result
end

function all_measured_quantum_search(qss::QSearch{T} where T<:DiscrQWalk,
                                     runtime::Int)
   @assert runtime >= 0 "Time needs to be nonnegative"
   result = zeros(Float64, (nv(graph(qss)), runtime+1)) # +1 to include 0

   state = initial_state(qss)
   result[:,1] = measure(qss, state)

   for t=1:runtime
      state = evolve(qss, state)
      result[:,t+1] = measure(qss, state) #evolution starts with t=0
   end

   result
end

function quantum_search(qss::QSearch{T} where T<:DiscrQWalk,
                        runtime::Int)
   @assert runtime >= 0 "Time needs to be nonnegative"

   state = initial_state(qss)
   for t=1:runtime
      state = evolve(qss, state)
   end

   QSearchState(qss, state, runtime)
end

function maximize_quantum_search(qss::QSearch{S} where S<:DiscrQWalk,
                                 maxtime::Int = nv(graph(qss)),
                                 mode::Symbol = :maxeff)
   @assert maxtime >= 0 "Time needs to be nonnegative"
   @assert mode ∈ [:firstmaxprob, :firstmaxeff, :maxtimeeff, :maxeff, :maxtimeprob] "stopcondition not implemented"


   best_result = QSearchState(qss, initial_state(qss), 0)
   for t=1:maxtime
      state = QSearchState(qss, evolve(qss, best_result), t)
      stopsearchflag = stopsearch(best_result, state, mode)
      best_result = max(best_result, state, mode)

      if stopsearchflag
         break
      end
   end

   best_result
end

function stopsearch(previous_state::QSearchState,
                    state::QSearchState,
                    mode::Symbol)

   if mode == :maxeff
      return expected_runtime(previous_state) < state.time
   elseif mode == :firstmaxprob
      return previous_state.probability > state.probability
   elseif mode == :firstmaxeff
      return expected_runtime(previous_state) < expected_runtime(state)
   else # include :maxtime case, should be considered by outside loop (hack?)
      return false
   end
end

function max(state1::QSearchState,
             state2::QSearchState,
             mode::Symbol)
   if mode ∈ [:firstmaxprob,:maxtimeprob]
      state1.probability > state2.probability ? state1 : state2
   else
      expected_runtime(state1) < expected_runtime(state2) ? state1 : state2
   end
end
