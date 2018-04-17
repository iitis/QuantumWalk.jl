using QuantumWalk
using LightGraphs

importall QuantumWalk
##

abstract type AbstractStochastic <: QWModelDiscr end

struct UniformStochastic{G<:SimpleGraph} <: AbstractStochastic
  graph::G
end

UniformScaling(digraph::G) where G= UniformStochastic{G}(digraph)

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

function initial_state(qws::QWSearch{<:AbstractStochastic})
  n = nv(graph(qws))
  fill(1./n, n)
end

function stochastic_matrix(g::SimpleGraph)
  a = adjacency_matrix(g)
  a*spdiagm(mapslices(x->1/sum(x), a, 1)[1,:])
end

function stochastic_evolution(s::SparseMatrixCSC{T}, v::Vector{T}) where T<:Real
  s*v
end

function evolve(qws::QWSearch{<:AbstractStochastic}, state::Vector{<:Real})
  old_probability = measure(qws, state, marked(qws))
  state[marked(qws)] = zero(marked(qws))
  state = stochastic_evolution(parameters(qws)[:stochastic], state)
  state[marked(qws)] += old_probability
  state
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

n = 100
penalty_stoch = log(n)
dynamic = QWSearch(UniformStochastic(CompleteGraph(n)), [1], penalty_stoch)

execute_single(dynamic, 40)
