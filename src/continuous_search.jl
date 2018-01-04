export
   quantum_search,
   maximize_quantum_search

"""
    quantum_search(qss::QSearch{<:ContQWalk}, runtime)

Simulates a continuous quantum walk evolution for time `runtime` according
to QSearch `qss`. QSearchState is returned. `runtime` needs to be nonnegative
real number.

```@doc
julia> qss = QSearch(CTQW(CompleteGraph(4)), [1]);

julia> result = quantum_search(qss, 10)
QSpatialSearch.QSearchState{Array{Complex{Float64},1},Int64}(Complex{Float64}[0.0110002+0.548218im, -0.188718+0.444407im, -0.188718+0.444407im, -0.188718+0.444407im], [0.300664], 10)

julia> probability(result)
1-element Array{Float64,1}:
 0.300664

```
"""
function quantum_search(qss::QSearch{<:ContQWalk}, runtime::Real)
   @assert runtime >= 0 "Time needs to be nonnegative"

   state = evolve(qss, initial_state(qss), runtime)
   QSearchState(qss, state, runtime)
end

"""
    maximize_quantum_search(qss::QSearch{<:ContQWalk} [, maxtime, tstep])

Determines optimal runtime for continuous quantum walk models. The time is
searched in [0, maxtime] interval, with penalty `penalty(qss)`, which is added.
It is recommended for penalty to be nonzero, otherwise time close to 0 is usually
returned. Typically small `penalty` approximately equal to log(n) is enough, but
optimal value may depend on the model or graph chosen.

The optimal time is chosen according to expected runtime, which equals to
runtime over probability, which simulates the Bernoulli process based on
`ContQWalk`.

`tstep` is used for primary grid search to search for determine intervale which
is supsected to have small expected runtime. To large value may miss the optimal value,
while to small may greatly increase runtime of the algorithm.

`maxtime` defaults to graph order n, `tstep` defaults to `sqrt(n)/5`. `QSearchState`
is returned by deafult without `penalty`. Note that in general the probability is not maximal


```@doc
julia> using QSpatialSearch,LightGraphs

julia> qss = QSearch(CTQW(CompleteGraph(100)), [1], 0.01, 1.);

julia> result = maximize_quantum_search(qss)
QSpatialSearch.QSearchState{Array{Complex{Float64},1},Float64}(Complex{Float64}[0.621142+0.695665im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im  …  0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im], [0.869767], 12.99636940469214)

julia> expected_runtime(result)
14.94235723559316

julia> probability(result)
1-element Array{Float64,1}:
 0.869767

julia> probability(quantum_search(qss, pi*sqrt(100)/2))
1-element Array{Float64,1}:
 1.0
```
"""
function maximize_quantum_search(qss::QSearch{<:ContQWalk},
                                 maxtime::T = Float64(nv(graph(qss))),
                                 tstep::T = Float64(0.2*sqrt(nv(graph(qss))))) where T<:Real
   @assert maxtime >= 0. "Time needs to be nonnegative"

   state = initial_state(qss)
   function efficiency_opt(runtime::Number)
      expected_runtime(runtime+penalty(qss), sum(measure(qss, evolve(qss, state, runtime), marked(qss))))
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
   mint = max(zero(T), data_t[max(1, minindex-1)])
   maxt = min(maxtime, data_t[min(length(data_t), minindex+1)])
   optresult = optimize(efficiency_opt, mint, maxt)

   result = quantum_search(qss, Optim.minimizer(optresult))
   QSearchState(result.state, result.probability, result.runtime+qss.penalty)
end
