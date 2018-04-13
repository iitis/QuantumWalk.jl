export
    QWSearch,
    marked,
    penalty,
    QSearchState,
    state,
    probability,
    runtime


"""
    QWSearch(model, marked, parameters, penalty)

Simulates quantum search on `model` with `marked` vertices and additional `parameters`.
`penalty` represents the cost of initial state creation and measurement, which should
be included for better optimization, see documentation of `maximizing_function`.

Needs implementation of
* `initial_state(::QWEvolution)`
* `evolve(::QWEvolution{<:QWModelDiscr}, state)` or `evolve(::QWEvolution{<:QWModelCont}, state, time::Real)`
* `measure(::QWEvolution, state)`
* `check_qwdynamics(::QWModelDiscr, parameters::Dict{Symbol})`
* proper constructors.

Offers functions
* `execute`
* `execute_single`
* `execute_single_measured`
* `execute_all`
* `execute_all_measured`
* `maximize_quantum_search`
* `expected_runtime`
and type `QSearchState`.
"""
struct QWSearch{T,W<:Real} <: QWDynamics{T}
  model::T
  marked::Array{Int}
  parameters::Dict{Symbol}
  penalty::W

  function QWSearch(model::T,
                    marked::Array{Int},
                    parameters::Dict{Symbol},
                    penalty::W) where {T<:QWModel, W<:Real}
    @assert all(1 <= v <= nv(model.graph) for v=marked) && marked != [] "marked needs to be non-empty subset of graph vertices set"

    check_qwdynamics(QWSearch, model, marked, parameters)
    new{T,W}(model, marked, parameters, penalty)
  end
end

"""
    marked(qss)

Returns `marked` element of `qss`.

```jldoctest
julia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])
QuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,
  [1, 1]  =  1.0+0.0im
  [2, 1]  =  0.333333+0.0im
  [3, 1]  =  0.333333+0.0im
  [4, 1]  =  0.333333+0.0im
  [1, 2]  =  0.333333+0.0im
  [3, 2]  =  0.333333+0.0im
  [4, 2]  =  0.333333+0.0im
  [1, 3]  =  0.333333+0.0im
  [2, 3]  =  0.333333+0.0im
  [4, 3]  =  0.333333+0.0im
  [1, 4]  =  0.333333+0.0im
  [2, 4]  =  0.333333+0.0im
  [3, 4]  =  0.333333+0.0im)), 0.0)

julia> marked(qss)
1-element Array{Int64,1}:
 1
```
"""
marked(qss::QWSearch) = qss.marked

"""
    penalty(qss)

Returns `penalty` element of `qss`.

```jldoctest
julia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])
QuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,
  [1, 1]  =  1.0+0.0im
  [2, 1]  =  0.333333+0.0im
  [3, 1]  =  0.333333+0.0im
  [4, 1]  =  0.333333+0.0im
  [1, 2]  =  0.333333+0.0im
  [3, 2]  =  0.333333+0.0im
  [4, 2]  =  0.333333+0.0im
  [1, 3]  =  0.333333+0.0im
  [2, 3]  =  0.333333+0.0im
  [4, 3]  =  0.333333+0.0im
  [1, 4]  =  0.333333+0.0im
  [2, 4]  =  0.333333+0.0im
  [3, 4]  =  0.333333+0.0im)), 0.0)

julia> penalty(qss)
0.0
```
"""
penalty(qss::QWSearch) = qss.penalty


"""
    QSearchState(state, probability, runtime)
    QSearchState(qss, state, runtime)

Creates container which consists of `state`, success probability `probability`
and running time `runtime`. Validity of `probability` and `runtime` is not checked.

In second case `state` is measured according to `qss` is made.

```jldoctest
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> result = QSearchState(qss, initial_state(qss), 0)
QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.288675
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
  probability::Vector{Float64}
  runtime::Y

  function QSearchState(state::S,
                        probability::Vector{Float64},
                        runtime::Y) where {S,Y<:Real}
     new{S,Y}(state, probability, runtime)
  end
end

function QSearchState(qss::QWSearch, state, runtime::Real)
   QSearchState(state, measure(qss, state, qss.marked), runtime)
end

function QSearchState(qss::QWSearch, state::Vector{Float64}, runtime::Real)
   QSearchState(state, measure(qss, state, qss.marked), runtime)
end

"""
    state(qsearchstate)

Returns the state of qsearchstate.

```jldoctest
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

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

```jldoctest
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

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

```jldoctest
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> result = QSearchState(qss, initial_state(qss), 0);

julia> runtime(result)
0

```
"""
runtime(qsearchstate::QSearchState) = qsearchstate.runtime


# documentation for
"""
    check_qwdynamics(model, marked, parameters)

Checks whetver combination of `model`, `marked` and `parameters` creates valid
quantum search evolution. Note that whetver list of vertices `marked` are a subset
of vertices of `graph` from `model` is checked seperately in `QWSearch` constructor.

Details concerning implementing `check_qwdynamics` for own models can be found in GitHub pages.
"""
check_qwdynamics(::QWSearch, ::Vector{Int}, ::Dict{Symbol})

"""
    initial_state(qss)

Generates initial state for QWSearch `qss`. The type and value strongly depends on
model of `qss`. For concrete `model` description please type `?initial_state(QWSearch{model})`,
for example for `CTQW` write `?initial_state(QWSearch{CTQW})`.

Details concerning implementing `initial_state` for own models can be found in GitHub pages.
"""
initial_state

include("qwsearch_dynamics.jl")
include("qwsearch_util.jl")
include("maximizing_function.jl")
