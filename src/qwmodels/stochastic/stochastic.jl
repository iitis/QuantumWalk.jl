using QuantumWalk
using LightGraphs


abstract type AbstractStochastic <: QWModelDiscr end

struct Stochastic{T<:AbstractMatrix{<:Real}, G<:SimpleGraph} <: AbstractStochastic
  stochastic_matrix::T
  graph::G
end

struct UniformStochastic{G<:SimpleGraph} <: AbstractStochastic
  graph::G
end

function check_qwdynamics(::Type{QWEvolution},
                          abs_stoch::Stochastic,
                          parameters::Dict{Symbol,Any})
  @assert :stochastic ∈ keys(parameters) "parameters needs to have key stochastic"
  n = nv(graph(abs_stoch))
  @assert isa(parameters[:stochastic], AbstractMatrix{<:Real}) "value for :stochastic needs to be sparse matrix with real numbers"
  @assert size(parameters[:stochastic], 1) == size(parameters[:stochastic], 2) "Stochastic matrix needs to be square stochastic matrix"
  @assert mapslices(sum, parameters[:stochastic], 1)[1,:] ≈ ones(n) "Stochastic matrix needs to be square stochastic matrix of order graph"
end

function stochastic_matrix(model::Stochastic)
  return model.stochastic_matrix
end

function stochastic_matrix(model::UniformStochastic)
  return stochastic_matrix(graph(model))
end

function QWEvolution(stoch::AbstractStochastic)
   parameters = Dict{Symbol,Any}(:stochastic => stochastic_matrix(stoch))
   QWEvolution(stoch, parameters)
end

function check_qwdynamics(::Type{QWSearch},
                          abs_stoch::UniformStochastic,
                          ::Vector{Int},
                          parameters::Dict{Symbol,Any})
  @assert :stochastic ∈ keys(parameters) "parameters needs to have key stochastic"
  n = nv(graph(abs_stoch))
  @assert isa(parameters[:stochastic], SparseMatrixCSC{<:Real}) "value for :stochastic needs to be sparse matrix with real numbers"
  @assert size(parameters[:stochastic], 1) == size(parameters[:stochastic], 2) "Stochastic matrix needs to be square stochastic matrix"
  @assert mapslices(sum, parameters[:stochastic], 1)[1,:] ≈ ones(n) "Stochastic matrix needs to be square stochastic matrix of order graph"
end

function QWSearch(stoch::AbstractStochastic,
                  marked::Vector{Int},
                  penalty::Real = 0.)
   parameters = Dict{Symbol,Any}(:stochastic => stochastic_matrix(graph(stoch)))

   QWSearch(stoch, marked, parameters, penalty)
end
