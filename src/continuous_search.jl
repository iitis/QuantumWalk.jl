export
   quantum_search,
   maximize_quantum_search

function evolve(qss::QSearch, state::QSearchState, runtime::T) where T<:Real
   evolve(qss, state.state, runtime)
end

function quantum_search(qss::QSearch{S} where S<:ContQWalk,
                        runtime::T) where T<:Real
   @assert runtime >= 0 "Time needs to be nonnegative"

   state = evolve(qss, initial_state(qss), runtime)
   QSearchState(qss, state, runtime)
end


function maximize_quantum_search(qss::QSearch{S} where S<:ContQWalk,
                                 maxtime::T = Float64(nv(graph(qss))),
                                 tstep::T = Float64(0.2*sqrt(nv(graph(qss))))) where {T<:Real}
   @assert maxtime >= 0. "Time needs to be nonnegative"

   state = initial_state(qss)
   efficiency_opt(runtime::T) where T<:Number = runtime/sum(measure(qss, evolve(qss, state, runtime)))

   t = 0.
   data_t = [0.01] #move from zero
   data_y = [Inf]

   max_efficiency = Inf
   while t <= maxtime
      t += tstep
      push!(data_t, t)
      push!(data_y, efficiency_opt(t))

      max_efficiency = min(max_efficiency, data_y[end])
      if max_efficiency <= t
         break
      end
   end

   if t > maxtime
      push!(data_t, maxtime)
      push!(data_y, efficiency_opt(maxtime))
   end

   minindex = findmin(data_y)[2]
   optresult = optimize(efficiency_opt, data_t[minindex-1], data_t[minindex-1])

   quantum_search(qss, Optim.minimizer(optresult))
end
