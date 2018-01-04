export
  QWalk,
  ContQWalk,
  DiscrQWalk,
  QWalkEvolution,
  QSearch,
  QWalkSimulator,
  graph,
  model,
  marked,
  parameters,
  penalty

"""
    QWalk
"""
abstract type QWalk end

"""
    ContQWalk
"""
abstract type ContQWalk <: QWalk end
"""
    DiscrQWalk
"""
abstract type DiscrQWalk <: QWalk end

"""
    QWalkEvolution
"""
abstract type QWalkEvolution{T<:QWalk} end

"""
    QSearch
"""
struct QSearch{T,W<:Real} <: QWalkEvolution{T}
  model::T
  marked::Array{Int}
  parameters::Dict{Symbol}
  penalty::W

  function QSearch(model::T,
                   marked::Array{Int},
                   parameters::Dict{Symbol},
                   penalty::W) where {T<:QWalk, W<:Real}
    @assert all(1 <= v <= nv(model.graph) for v=marked) && marked != [] "marked needs to be non-empty subset of graph vertices set"

    check_qss(model, marked, parameters)
    new{T,W}(model, marked, parameters, penalty)
  end
end

"""
    QWalkSimulator
"""
struct QWalkSimulator{T} <: QWalkEvolution{T}
  model::T
  parameters::Dict{Symbol}

  function QWalkSimulator(model::T,
                          parameters::Dict{Symbol}) where T<:QWalk
    check_qwalksimulator(model, parameters)
    new{T}(model, parameters)
  end
end

"""
    graph
"""
graph(model::QWalk) = model.graph
graph(qwe::QWalkEvolution) = graph(qwe.model)

"""
    model
"""
model(qwe::QWalkEvolution) = qwe.model

"""
    parameters
"""
parameters(qwe::QWalkEvolution) = qwe.parameters

"""
    marked
"""
marked(qss::QSearch) = qss.marked

"""
    penalty
"""
penalty(qss::QSearch) = qss.penalty
