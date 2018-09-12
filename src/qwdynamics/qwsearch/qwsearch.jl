export
    QWSearch,
    marked,
    penalty,
    QSearchState,
    state,
    probability,
    runtime


"""
    QWSearch(model, parameters, marked, penalty[; check])

Simulates quantum search on `model` with `marked` vertices and additional `parameters`.
`penalty` represents the cost of initial state creation and measurement, which should
be included for better optimization, see documentation of `maximizing_function`.
Note that marked vertices needs to be between `1` and `nv(graph(model))`. Furthermore
penalty needs to be nonnegative.

`check_qwdynamics` is executed if and only iff `check` is true.

Needs implementation of
* `initial_state(qws::QWSearch)`
* `evolve(qws::QWSearch{<:QWModelDiscr}, state)` or `evolve(qws::QWSearch{<:QWModelCont}, state, time::Real)`
* `measure(qws::QWSearch, state[, vertices])`
* `check_qwdynamics(QWSearch, model::QWModel, parameters::Dict{Symbol}, penalty::Real)`
* proper constructors.

Offers functions
* `execute`
* `execute_single`
* `execute_single_measured`
* `execute_all`
* `execute_all_measured`
* `maximize_quantum_search`.

It is encoureged to implement constructor, which changes the `penalty` and/or `marked`
vertices only, as their are usually simple to adapt.
"""
struct QWSearch{T,W<:Real} <: QWDynamics{T}
  model::T
  parameters::Dict{Symbol}
  marked::Vector{Int}
  penalty::W

  function QWSearch(model::T,
                    parameters::Dict{Symbol},
                    marked::Vector{Int},
                    penalty::W;
                    check::Bool=false) where {T<:QWModel, W<:Real}
    @assert all(1 <= v <= nv(model.graph) for v=marked) && marked != [] "marked vertices needs to be non-empty subset of graph vertices set"
    @assert penalty >= 0 "Penalty needs to be nonnegative"

    if check
        check_qwdynamics(QWSearch, model, parameters, marked)
    end
    new{T,W}(model, parameters, marked, penalty)
  end
end

function check_qwdynamics(qws::QWSearch)
    check_qwdynamics(QWSearch, model(qws), parameters(qws), marked(qws))
end

"""
    marked(qws)

Returns `marked` vertices element of `qws`.
"""
marked(qws::QWSearch) = qws.marked

"""
    penalty(qws)

Returns `penalty` element of `qws`.
"""
penalty(qws::QWSearch) = qws.penalty


"""
    QSearchState(state, probability, runtime, penalty)
    QSearchState(qws, state, runtime)

Creates container which consists of `state`, success probability `probability`,
running time `runtime` and penalty `penalty`.

In second case `state` is measured according to `qws`.

# Example
```jldoctest
julia> qws = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> result = QSearchState(qws, initial_state(qws), 0)
QSearchState{Array{Float64,1},Int64,Int64}([0.0, 0.288675, 0.288675, 0.288675, 0.288675, 0.0, 0.288675, 0.288675, 0.288675, 0.288675, 0.0, 0.288675, 0.288675, 0.288675, 0.288675, 0.0], [0.25], 0, 0)
```
"""
struct QSearchState{S,Y<:Real,T<:Real}
  state::S
  probability::Vector{Float64}
  runtime::Y
  penalty::T

  function QSearchState(state::S,
                        probability::AbstractVector{Float64},
                        runtime::Y,
                        penalty::T=0.) where {S,Y<:Real,T<:Real}
     @assert runtime >= zero(Y) "runtime needs to be nonnegative"
     @assert penalty >= zero(T) "penalty needs to be nonnegative"
     @assert all(0. .<= probability .<= 1.001) && sum(probability) <= 1.001 "probability is not a subprobability vector"

     new{S,Y,T}(state, Vector(probability), runtime, penalty)
  end
end

function QSearchState(qws::QWSearch, state, runtime::Real)
   QSearchState(state, measure(qws, state, qws.marked), runtime, penalty(qws))
end

# Following for resolving method ambiguity error
function QSearchState(qws::QWSearch, state::Vector{Float64}, runtime::Real)
   QSearchState(state, measure(qws, state, qws.marked), runtime, penalty(qws))
end

"""
    state(qsearchstate)

Returns the state of qsearchstate.
"""
state(qsearchstate::QSearchState) = qsearchstate.state

"""
    probability(qsearchstate)

Returns the list of probabilities of finding marked vertices.
"""
probability(qsearchstate::QSearchState) = qsearchstate.probability

"""
    runtime(qsearchstate)

Returns the time for which the state was calulated.
"""
runtime(qsearchstate::QSearchState) = qsearchstate.runtime

"""
    penalty(qsearchstate)

Returns the penalty time for which the state was calulated.
"""
penalty(qsearchstate::QSearchState) = qsearchstate.penalty

"""
    initial_state(qws)

Generates initial state for `qws`.
"""
initial_state(::QWSearch)

include("qwsearch_dynamics.jl")
include("qwsearch_util.jl")
include("maximizing_function.jl")
