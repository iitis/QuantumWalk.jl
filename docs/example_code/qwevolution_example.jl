using QuantumWalk
using LightGraphs

import QuantumWalk: check_qwdynamics, evolve, measure, QWEvolution
##

abstract type AbstractStochastic <: QWModelDiscr end

struct UniformStochastic{G<:SimpleGraph} <: AbstractStochastic
  graph::G
end

UniformScaling(digraph::G) where G= UniformStochastic{G}(digraph)

function check_qwdynamics(::Type{QWEvolution},
                          abs_stoch::UniformStochastic,
                          parameters::Dict{Symbol,Any})
  @assert :stochastic ∈ keys(parameters) "parameters needs to have key stochastic"
  n = nv(graph(abs_stoch))
  @assert isa(parameters[:stochastic], SparseMatrixCSC{<:Real}) "value for :stochastic needs to be sparse matrix with real numbers"
  @assert size(parameters[:stochastic], 1) == size(parameters[:stochastic], 2) "Stochastic matrix needs to be square stochastic matrix"
  @assert mapslices(sum, parameters[:stochastic], 1)[1,:] ≈ ones(n) "Stochastic matrix needs to be square stochastic matrix of order graph"
end

function stochastic_matrix(g::SimpleGraph)
  a = adjacency_matrix(g)
  a*spdiagm(mapslices(x->1/sum(x), a, 1)[1,:])
end

function QWEvolution(stoch::AbstractStochastic)
   parameters = Dict{Symbol,Any}(:stochastic => stochastic_matrix(graph(stoch)))
   QWEvolution(stoch, parameters)
end

function stochastic_evolution(s::SparseMatrixCSC{T}, v::Vector{T}) where T<:Real
  s*v
end

function evolve(qws::QWDynamics{<:AbstractStochastic}, state)
  stochastic_evolution(parameters(qws)[:stochastic], state)
end

function measure(::QWDynamics{<:AbstractStochastic}, state::Vector{<:Real})
   return state
end

function measure(::QWDynamics{<:AbstractStochastic},
                 state::Vector{<:Real},
                 vertices::Vector{Int})
   return state[vertices]
end

##

dynamic = QWEvolution(UniformStochastic(smallgraph(:bull)))

println(execute_single(dynamic, fill(1./5, 5), 5))
