export
   quantum_search,
   maximize_quantum_search,
   all_quantum_search,
   all_measured_quantum_search


function evolve(qss::QSearch, state::QSearchState)
   evolve(qss, state.state)
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
