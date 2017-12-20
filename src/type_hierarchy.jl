export
  QWalk,
  ContQWalk,
  DiscrQWalk,
  QSearch,
  QWalkSimulator,
  graph,
  model,
  marked,
  QSearchState

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
    QSearch
"""
struct QSearch{T<:QWalk}
  model::T
  marked::Array{Int}
  parameters::Dict{Symbol, S} where S
  penalty::W where W

  function QSearch(model::T ,
                   marked::Array{Int},
                   parameters::Dict{Symbol, X},
                   penalty::U) where {T<:QWalk, X<:Any, U<:Number}
    @assert all(1 <= v <= nv(model.graph) for v=marked) && marked != [] "marked needs to be non-empty subset of graph vertices set"

    check_qss(model, marked, parameters)
    new{T}(model, marked, parameters, penalty)
  end
end

"""
    QWalkSimulator
"""
struct QWalkSimulator{T<:QWalk}
  model::T
  parameters::Dict{Symbol, S} where S

  function QWalkSimulator(model::T,
                          parameters::Dict{Symbol, X}) where {T<:QWalk, X<:Any}
    check_qwalksimulator(model, parameters)
    new{T}(model, parameters)
  end
end

"""
    graph
"""
graph(qwalk::T where T<:QWalk) = qwalk.graph
graph(qsearch::T where T<:QSearch) = graph(qsearch.model)

"""
    model
"""
model(qsearch::T where T<:QSearch) = qsearch.model
model(qwalk::T where T<:QWalkSimulator) = qwalk.model

"""
    parameters
"""
parameters(qsearch::T where T<:QSearch) = qsearch.parameters
parameters(qwalk::T where T<:QWalkSimulator) = qwalk.parameters

"""
    marked
"""
marked(qsearch::T where T<:QSearch) = qsearch.marked


"""
    QSearchState
"""
struct QSearchState{S,P<:Real,Y<:Real}
  state::S
  probability::Array{P}
  time::Y

  function QSearchState(state::S,
                        probability::Array{P},
                        runtime::Y) where {S,P<:Real,Y<:Real}
     new{S,P,Y}(state, probability, runtime)
  end
end

function QSearchState(qss::QSearch,
                      state::S,
                      runtime::T) where {S,T<:Real}
   QSearchState(state, measure(qss, state), runtime)
end
