export
   quantum_search,
   maximize_quantum_search

"""
    quantum_search
"""
function quantum_search(qss::QSearch{<:ContQWalk}, runtime::Real)
   @assert runtime >= 0 "Time needs to be nonnegative"

   state = evolve(qss, initial_state(qss), runtime)
   QSearchState(qss, state, runtime)
end

"""
    maximize_quantum_search
"""
function maximize_quantum_search(qss::QSearch{<:ContQWalk},
                                 maxtime::T = Float64(nv(graph(qss))),
                                 tstep::T = Float64(0.2*sqrt(nv(graph(qss))))) where T<:Real
   @assert maxtime >= 0. "Time needs to be nonnegative"

   state = initial_state(qss)
   function efficiency_opt(runtime::Number) 
      expected_runtime(runtime+qss.penalty, sum(measure(qss, evolve(qss, state, runtime))))
   end

   t = zero(T)
   data_t = T[t]
   data_y = [efficiency_opt(t)]
   max_efficiency = data_y[end]
   for t=tstep:tstep:maxtime
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
   mint = max(zero(T), data_t[minindex-1])
   maxt = min(maxtime, data_t[minindex+1])
   optresult = optimize(efficiency_opt, mint, maxt)

   result = quantum_search(qss, Optim.minimizer(optresult))
   QSearchState(result.state, result.probability, result.time+qss.penalty)
end
