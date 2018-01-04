export
   quantum_search,
   maximize_quantum_search,
   all_quantum_search,
   all_measured_quantum_search

"""
    all_quantum_search(qss::QSearch{<:DiscrQWalk}, runtime)

Returns all step states of `qss` search from time 0 to `runtime`. List of `QSearchState`
is returned.

`runtime` needs to be nonnegative `Int`.

```@docs
julia> qss = QSearch(Szegedy(CompleteGraph(4)), [1]);

julia> all_quantum_search(qss, 2)
3-element Array{QSpatialSearch.QSearchState,1}:
 QSpatialSearch.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.288675
  [3 ]  =  0.288675
  [4 ]  =  0.288675
  [5 ]  =  0.288675
  [7 ]  =  0.288675
  [8 ]  =  0.288675
  [9 ]  =  0.288675
  [10]  =  0.288675
  [12]  =  0.288675
  [13]  =  0.288675
  [14]  =  0.288675
  [15]  =  0.288675, [0.25], 0)
 QSpatialSearch.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.481125
  [3 ]  =  0.481125
  [4 ]  =  0.481125
  [5 ]  =  -0.288675
  [7 ]  =  -0.096225
  [8 ]  =  -0.096225
  [9 ]  =  -0.288675
  [10]  =  -0.096225
  [12]  =  -0.096225
  [13]  =  -0.288675
  [14]  =  -0.096225
  [15]  =  -0.096225, [0.694444], 1)
 QSpatialSearch.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  -0.138992
  [3 ]  =  -0.138992
  [4 ]  =  -0.138992
  [5 ]  =  0.032075
  [7 ]  =  -0.395592
  [8 ]  =  -0.395592
  [9 ]  =  0.032075
  [10]  =  -0.395592
  [12]  =  -0.395592
  [13]  =  0.032075
  [14]  =  -0.395592
  [15]  =  -0.395592, [0.0579561], 2)
```
"""
function all_quantum_search(qss::QSearch{<:DiscrQWalk}, runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   result = QSearchState[]
   push!(result, QSearchState(qss, initial_state(qss), 0))

   for t=1:runtime
      push!(result, QSearchState(qss, evolve(qss, result[end]), t))
   end

   result
end

"""
    all_measured_quantum_search(qss::QSearch{<:DiscrQWalk}, runtime)

Returns probability of measurement of  all step states of `qss` search from time
0 to `runtime`. `Matrix{Float64}` is returned, where `i`-th column represents `i-1`
time.

`runtime` needs to be nonnegative `Int`.

```@docs
julia> qss = QSearch(Szegedy(CompleteGraph(4)), [1]);

julia> all_measured_quantum_search(qss, 4)
4×5 Array{Float64,2}:
 0.25  0.694444  0.0579561  0.112487  0.577169
 0.25  0.101852  0.314015   0.295838  0.140944
 0.25  0.101852  0.314015   0.295838  0.140944
 0.25  0.101852  0.314015   0.295838  0.140944

```
"""
function all_measured_quantum_search(qss::QSearch{<:DiscrQWalk}, runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"
   result = zeros(Float64, (nv(graph(qss)), runtime+1)) # +1 to include 0

   state = initial_state(qss)
   result[:,1] = measure(qss, state)

   for t=1:runtime
      state = evolve(qss, state)
      result[:,t+1] = measure(qss, state) #evolution starts with t=0
   end

   result
end

"""
    quantum_search(qss::QSearch{<:DiscrQWalk}, runtime)

Simulates a continuous quantum walk evolution for time `runtime` according
to QSearch `qss`. QSearchState is returned.

```@doc
julia> qss = QSearch(Szegedy(CompleteGraph(4)), [1]);

julia> result = quantum_search(qss, 4)
QSpatialSearch.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.438623
  [3 ]  =  0.438623
  [4 ]  =  0.438623
  [5 ]  =  0.104937
  [7 ]  =  0.254884
  [8 ]  =  0.254884
  [9 ]  =  0.104937
  [10]  =  0.254884
  [12]  =  0.254884
  [13]  =  0.104937
  [14]  =  0.254884
  [15]  =  0.254884, [0.577169], 4)

julia> measure(qss, result)
4-element Array{Float64,1}:
 0.577169
 0.140944
 0.140944
 0.140944


```
"""
function quantum_search(qss::QSearch{<:DiscrQWalk}, runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   state = initial_state(qss)
   for t=1:runtime
      state = evolve(qss, state)
   end

   QSearchState(qss, state, runtime)
end

"""
   maximize_quantum_search(qss::QSearch{<:DiscrQWalk} [, runtime, mode])

Determines optimal runtime for continuous quantum walk models. The time is
searched in [0, runtime] interval, with penalty `penalty(qss)`, which is added.
It is recommended for penalty to be nonzero, otherwise time close 0 is returned.
Typically small `penalty` approximately equal to log(n) is enough, but
optimal value may depend on the model or graph chosen.

The optimal time depende on chosen `mode`:
* `:firstmaxprob` stops when probability start to decrease,
* `:firstmaxeff` stops whene expected runtime start to increase,
* `:maxtimeeff` chooses exhaustively the time from [0, runtime] with smallest expected time,
* `:maxtimeprob` chooses exhaustively the time from [0, runtime] with maximal success probability,
* `:maxeff` (default) finds optimal time with smallest expected time, usually faster
than `:maxtimefff`.

Note last three modes always returns optimal time within the interval.

`maxtime` defaults to graph order n, `mode` defaults to `:maxeff`. `QSearchState`
is returned by deafult without `penalty`.

```@docs
julia> qss = QSearch(Szegedy(CompleteGraph(200)), [1], 1);

julia> result = maximize_quantum_search(qss);

julia> runtime(result)
7

julia> probability(result)
1-element Array{Float64,1}:
 0.500016

julia> result = maximize_quantum_search(qss, 100, :maxtimeprob);

julia> runtime(result)
40

julia> probability(result)
1-element Array{Float64,1}:
 0.550938
```
"""
function maximize_quantum_search(qss::QSearch{<:DiscrQWalk},
                                 runtime::Int = nv(graph(qss)),
                                 mode::Symbol = :maxeff)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"
   @assert mode ∈ [:firstmaxprob, :firstmaxeff, :maxtimeeff, :maxeff, :maxtimeprob] "Specified stop condition is not implemented"

   best_result = QSearchState(qss, initial_state(qss), qss.penalty)
   state = QSearchState(qss, initial_state(qss), qss.penalty)
   for t=1:runtime
      state = QSearchState(qss, evolve(qss, state), t+qss.penalty)
      stopsearchflag = stopsearch(best_result, state, mode)
      best_result = best(best_result, state, mode)

      if stopsearchflag
         break
      end
   end

   best_result
end

"""
    stopsearch(previous_state, state, mode)

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

function stopsearch(previous_state::QSearchState,
                    state::QSearchState,
                    mode::Symbol)
   if mode == :maxeff
      return expected_runtime(previous_state) < state.runtime+1 #check whetver needs to analyze next step
   elseif mode == :firstmaxprob
      return sum(previous_state.probability) > sum(state.probability)
   elseif mode == :firstmaxeff
      return expected_runtime(previous_state) < expected_runtime(state)
   else # include :maxtime case, should be considered by outside loop (hack?)
      return false
   end
end

"""
    best(state1, state2, mode)

Choose better state depending on mode. If success probability is maximized, then
the success probability is compared. If expected runtime is minimized,
then expected runtime is compared.
"""
function best(state1::QSearchState,
              state2::QSearchState,
              mode::Symbol)
   if mode ∈ [:firstmaxprob,:maxtimeprob]
      sum(state1.probability) > sum(state2.probability) ? state1 : state2
   else
      expected_runtime(state1) < expected_runtime(state2) ? state1 : state2
   end
end
