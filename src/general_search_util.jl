export
   QSearchState,
   state,
   probability,
   runtime,
   expected_runtime

"""
    QSearchState(state, probability, runtime)
    QSearchState(qss, state, runtime)

Creates container which consists of `state`, success probability `probability`
and running time `runtime`. Validity of `probability` and `runtime` is not checked.

In second case `state` is measured according to `qss` is made.

```@docs
julia> qss = QSearch(Szegedy(CompleteGraph(4)), [1]);

julia> result = QSearchState(qss, initial_state(qss), 0)
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
```
"""
struct QSearchState{S,Y<:Real}
  state::S
  probability::Array{Float64}
  runtime::Y

  function QSearchState(state::S,
                        probability::Array{Float64},
                        runtime::Y) where {S,Y<:Real}
     new{S,Y}(state, probability, runtime)
  end
end

function QSearchState(qss::QSearch, state, runtime::Real)
   QSearchState(state, measure(qss, state, qss.marked), runtime)
end

"""
    state(qsearchstate)

Returns the state of qsearchstate.

```@docs
julia> qss = QSearch(Szegedy(CompleteGraph(4)), [1]);

julia> result = QSearchState(qss, initial_state(qss), 0);

julia> state(result)
16-element SparseVector{Float64,Int64} with 12 stored entries:
  [2 ]  =  0.288675
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
  [15]  =  0.288675
```
"""
state(qsearchstate::QSearchState) = qsearchstate.state

"""
    probability(qsearchstate)

Returns the list of probabilities of finding marked vertices.

```@docs
julia> qss = QSearch(Szegedy(CompleteGraph(4)), [1]);

julia> result = QSearchState(qss, initial_state(qss), 0);

julia> probability(result)
1-element Array{Float64,1}:
 0.25

```
"""
probability(qsearchstate::QSearchState) = qsearchstate.probability

"""
    runtime(qsearchstate)

Returns the time for which the state was calulated.

```@docs
julia> qss = QSearch(Szegedy(CompleteGraph(4)), [1]);

julia> result = QSearchState(qss, initial_state(qss), 0);

julia> runtime(result)
0

```
"""
runtime(qsearchstate::QSearchState) = qsearchstate.runtime


#measure decorating functions
function measure(qwe::QWalkEvolution, state::QSearchState)
   measure(qwe, state.state)
end

function measure(qwe::QWalkEvolution, state::QSearchState, vertices::Array{Int})
   measure(qwe, state.state, vertices)
end

#Evolve decorating function
function evolve(qwe::QWalkEvolution, state::QSearchState)
   evolve(qwe, state.state)
end

function evolve(qwe::QWalkEvolution, state::QSearchState, runtime::T) where T<:Real
   evolve(qwe, state.state, runtime)
end

#Expected runtime
"""
    expected_runtime(runtime, probability)
    expected_runtime(state)

Returns the expected runtime needed for quantum walk, considering it as Bernoulli
process. It equals to `runtime/probability`. In the case of `state` provided the
measurement is made.

```@docs
julia> qss = QSearch(Szegedy(CompleteGraph(4)), [1]);

julia> result = quantum_search(qss, 4);

julia> expected_runtime(result)
6.930377097077988

julia> expected_runtime(runtime(result), sum(probability(result)))
6.930377097077988
```
"""
function expected_runtime(runtime::Real,
                          probability::Real)
   runtime/probability
end

function expected_runtime(state::QSearchState)
   expected_runtime(state.runtime, sum(state.probability))
end
