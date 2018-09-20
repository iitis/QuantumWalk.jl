export
   maximize_quantum_search

"""
    maximize_quantum_search(qws_cont [, maxtime, tstep])

Determines optimal runtime for continuous quantum walk search. The time is
searched in [0, maxtime] interval, with penalty `penalty(qws_cont)`.
It is recommended for penalty to be nonzero, otherwise time close to 0 is usually
returned. Typically `penalty` equal to `log(nv(graph(qws_cont)))` is enough, but
optimal value may depend on the model or graph chosen.

The optimal time is chosen according to expected runtime, which equals to
runtime over probability. This comes from interpreting the evolution as the
Bernoulli process.

`tstep` is used for primary grid search to search for determine intervale which
is supsected to have small expected runtime. To large value may miss the optimal value,
while to small may greatly increase runtime of the algorithm.

`maxtime` defaults to graph order n, `tstep` defaults to `sqrt(n)/5`. Note that in general the probability is not maximal.

```jldoctest
julia> qws = QWSearch(CTQW(CompleteGraph(100)), [1], 1., 0.01);

julia> result = maximize_quantum_search(qws)
QSearchState{Array{Complex{Float64},1},Float64,Float64}(Complex{Float64}[0.621142+0.695665im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im  …  0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im], [0.869767], 11.996369403338626, 1.0)

julia> probability(result)
1-element Array{Float64,1}:
 0.8697670118862033
```
"""
function maximize_quantum_search(qws::QWSearch{<:QWModelCont},
                                 maxtime::T = Float64(nv(graph(qws))),
                                 tstep::T = Float64(0.2*sqrt(nv(graph(qws))))) where T<:Real
   @assert maxtime >= 0. "Parameter 'maxtime' needs to be nonnegative"
   @assert tstep > 0. "Parameter 'tstep' needs to be positive"

   if penalty(qws) == 0
      @warn "It is recommended for the penalty to be nonzero. Otherwise, the time close to zero may be returned. "*
      "Typically penalty should be approximately log(n), but this might by case-dependant."
   end

   state = initial_state(qws)
   function efficiency_opt(runtime::Number)
      expected_runtime(runtime+penalty(qws), sum(measure(qws, evolve(qws, state, runtime), marked(qws))))
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

   if t > maxtime-tstep
      push!(data_t, maxtime)
      push!(data_y, efficiency_opt(maxtime))
   end


   minindex = findmin(data_y)[2]

   mint = max(zero(T), data_t[max(1, minindex-1)])
   maxt = min(maxtime, data_t[min(length(data_t), minindex+1)])

   optresult = optimize(efficiency_opt, mint, maxt)
   result = execute_single(qws, Optim.minimizer(optresult))
   QSearchState(result.state, result.probability, result.runtime, penalty(qws))
end

"""
    maximize_quantum_search(qws_discr [, runtime, mode])

Determines optimal runtime for discrete quantum walk search. The time is
searched in [0, runtime] interval, with penalty `penalty(qws_discr)`.
It is recommended for penalty to be nonzero, otherwise time close 0 is returned.
Typically small `penalty` approximately equal to log(n) is enough, but
optimal value may depend on the model or graph chosen.

The optimal time depends on chosen `mode`:
* `:firstmaxprob` stops when probability start to decrease,
* `:firstmaxeff` stops when expected runtime start to increase,
* `:maxtimeeff` chooses exhaustively the time from [0, runtime] with smallest expected time,
* `:maxtimeprob` chooses exhaustively the time from [0, runtime] with maximal success probability,
* `:maxeff` (default) finds optimal time with smallest expected time, usually faster than `:maxtimefff`.

Note last three modes always returns optimal time within the interval.

`maxtime` defaults to graph order n, `mode` defaults to `:maxeff`.

```jldoctest
julia> qws = QWSearch(Szegedy(CompleteGraph(200)), [1], 1);

julia> result = maximize_quantum_search(qws);

julia> runtime(result)
6

julia> probability(result)
1-element Array{Float64,1}:
 0.5000160413993847

julia> result = maximize_quantum_search(qws, 100, :maxtimeprob);

julia> runtime(result)
39

julia> probability(result)
1-element Array{Float64,1}:
 0.5509378780415133
```
"""
function maximize_quantum_search(qws::QWSearch{<:QWModelDiscr},
                                 runtime::Int = nv(graph(qws)),
                                 mode::Symbol = :maxeff)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"
   @assert mode ∈ [:firstmaxprob, :firstmaxeff, :maxtimeeff, :maxeff, :maxtimeprob] "Specified stop condition is not implemented"
   if penalty(qws) == 0
      @warn "It is recommended for the penalty to be nonzero. Otherwise, the time close to zero is returned. "*
      "Typically penalty should be approximately log(n), but this might by case-dependant."
   end


   best_result = QSearchState(qws, initial_state(qws), 0)
   state = QSearchState(qws, initial_state(qws), 0)
   for t=1:runtime
      state = QSearchState(qws, evolve(qws, state), t)
      stopsearchflag = stopsearch(qws, best_result, state, mode)
      best_result = best(qws, best_result, state, mode)

      if stopsearchflag
         break
      end
   end

   best_result
end

"""
    stopsearch(qws, previous_state, state, mode)

For given combination of argument decides whetver maximizing search function
should be stopped:
The optimal time depende on chosen `mode`:
* `:firstmaxprob` stops when probability start to decrease,
* `:firstmaxeff` stops whene expected runtime start to increase,
* `:maxtimeeff` always return `false` (should be decided by external function),
* `:maxtimeprob`  always return `false` (should be decided by external function),
* `:maxeff` checks whetver expected_runtime of older state is smaller than current time,

`false` means maximizing should continue unless other constraints, `true` otherwise.
"""
function stopsearch(qws::QWSearch,
                    prev_state::QSearchState,
                    state::QSearchState,
                    mode::Symbol)
   if mode == :maxeff
      return expected_runtime(qws, prev_state) < state.runtime+1 #check whetver needs to analyze next step
   elseif mode == :firstmaxprob
      return sum(prev_state.probability) > sum(state.probability)
   elseif mode == :firstmaxeff
      return expected_runtime(qws, prev_state) < expected_runtime(qws, state)
   else # include :maxtime case, should be considered by outside loop (hack?)
      return false
   end
end

"""
    best(qws, state1, state2, mode)

Choose better state depending on mode. If success probability is maximized, then
the success probability is compared. If expected runtime is minimized,
then expected runtime is compared.
"""
function best(qws::QWSearch,
              state1::QSearchState,
              state2::QSearchState,
              mode::Symbol)
   if mode ∈ [:firstmaxprob,:maxtimeprob]
      sum(state1.probability) > sum(state2.probability) ? state1 : state2
   else
      expected_runtime(qws, state1) < expected_runtime(qws, state2) ? state1 : state2
   end
end
