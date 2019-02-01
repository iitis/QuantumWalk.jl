using QuantumWalk
using LightGraphs

export
    AbstractStochastic,
    Stochastic,
    UniformStochastic,
    stochastic_matrix

"""
    AbstractStochastic

Type representing the abstract stochastic random walk model. Default
representation of `AbstractStochastic` is `Stochastic`.
"""
abstract type AbstractStochastic <: QWModelDiscr end

"""
    Stochastic{G<:SimpleGraph}(stochastic, graph)

Default representation of `AbstractStochastic`. Argument `stochastic` is
stochastic matrix representing `graph`.
"""
struct Stochastic{T<:AbstractMatrix{<:Real}, G<:SimpleGraph} <: AbstractStochastic
  stochastic_matrix::T
  graph::G
end

"""
    UniformStochastic{G<:SimpleGraph}(graph)

Representation of uniform quantum walk, where each step direction is equiprobable.
"""
struct UniformStochastic{G<:SimpleGraph} <: AbstractStochastic
  graph::G
end

function check_qwmodel(abs_stoch::AbstractStochastic,
                       parameters::Dict{Symbol,Any})
   @assert :stochastic ∈ keys(parameters) "parameters needs to have key stochastic"
   n = nv(graph(abs_stoch))
   @assert isa(parameters[:stochastic], AbstractMatrix{<:Real}) "value for :stochastic needs to be sparse matrix with real numbers"
   @assert size(parameters[:stochastic], 1) == size(parameters[:stochastic], 2) "Stochastic matrix needs to be square stochastic matrix"
   @assert mapslices(sum, parameters[:stochastic], dims=[1])[1,:] ≈ ones(n) "Stochastic matrix needs to be square stochastic matrix of order graph"
end

"""
    check_qwdynamics(QWEvolution, stochastic, parameters)

Check whetver combination of `stochastic`, and `parameters` produces a
valid `QWEvolution` object. It checks where `parameters` consists of key
`:stochastic` with corresponding value being a `AbstractMatrix` object, which is
right stochastic matrix.
Furthermore operators need to be square of size equals to square of the order of
`graph(szegedy)`.
"""
function check_qwdynamics(::Type{QWEvolution},
                          abs_stoch::AbstractStochastic,
                          parameters::Dict{Symbol,Any})
   check_qwmodel(abs_stoch, parameters)
end

"""
    stochastic_matrix(model::Stochastic[, node])

Returns the `stochastic` element of `model`. If `node` is specified, outputs
only `node`th column.
"""
function stochastic_matrix(model::Stochastic)
  return model.stochastic_matrix
end

function stochastic_matrix(model::Stochastic, node::Int)
  return model.stochastic_matrix[:, node]
end
"""
    stochastic_matrix(model::UniformStochastic[, node])

COMPUTES and returns the stochastic matrix for uniform random walk. If `node` is
specified, outputs only `node`th column.
"""
function stochastic_matrix(model::UniformStochastic)
  return uniform_stochastic(graph(model))
end

function stochastic_matrix(model::UniformStochastic, node::Int)
  return uniform_stochastic(graph(model), node)
end

"""
    QWEvolution(stochastic)

Create `QWEvolution` according to `AbstractStochastic` model.
"""
function QWEvolution(stoch::AbstractStochastic)
   parameters = Dict{Symbol,Any}(:stochastic => stochastic_matrix(stoch))
   QWEvolution(stoch, parameters)
end

"""
    check_qwdynamics(QWSearch, stochastic, parameters)

Check whetver combination of `stochastic`, and `parameters` produces a
valid `QWEvolution` object. It checks where `parameters` consists of key
`:stochastic` with corresponding value being a `AbstractMatrix` object, which is
right stochastic matrix.
Furthermore operators need to be square of size equals to square of the order of
`graph(szegedy)`.
"""
function check_qwdynamics(::Type{QWSearch},
                          abs_stoch::AbstractStochastic,
                          parameters::Dict{Symbol,Any},
                          ::Vector{Int})
   check_qwmodel(abs_stoch, parameters)
end

"""
    QWSearch(stoch, marked[, penalty])

Creates `QWSearch` according to `AbstractStochastic` model. By default parameter
`penalty` is set to 0. Evolution operators stochastic matrices, where the only
outgoing arcs for elements in `marked` are loops.

    QWSearch(qws[; marked, penalty])

Update quantum walk search to new subset of marked elements and new penalty. By
default `marked` and `penalty` are the same as in `qws`.
"""
function QWSearch(stoch::AbstractStochastic,
                  marked::Vector{Int},
                  penalty::Real = 0.)
    evolution_matrix = copy(stochastic_matrix(stoch))

    for m in marked
        evolution_matrix[:, m] = zeros(nv(graph(stoch)))
        evolution_matrix[m, m] = 1
    end

    parameters = Dict{Symbol,Any}(:stochastic => evolution_matrix)
    QWSearch(stoch, parameters, marked, penalty)
end

function QWSearch(qws::QWSearch{<:AbstractStochastic};
                  marked::Vector{Int}=qws.marked,
                  penalty::Real=qws.penalty)
   oldmarked = Set(qws.marked)
   newmarked = Set(marked)
   evolution_matrix = copy(parameters(qws)[:stochastic])

   for node in setdiff(newmarked, oldmarked)
       evolution_matrix[:, node] = zeros(nv(graph(qws)))
       evolution_matrix[node, node] = 1
   end
   for node in setdiff(oldmarked, newmarked)
       evolution_matrix[:, node] = stochastic_matrix(model(qws), node)
   end

   QWSearch(model(qws), Dict{Symbol,Any}(:stochastic => evolution_matrix), marked, penalty)
end


include("stochastic_evolution.jl")
