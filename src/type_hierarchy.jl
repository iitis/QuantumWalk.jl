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

abstract type QWalk end

abstract type ContQWalk <: QWalk end
abstract type DiscrQWalk <: QWalk end

struct QSearch{T<:QWalk}
  model::T
  marked::Array{Int}
  parameters::Dict{Symbol, S} where S
  penalty::W where W

  function QSearch{T}(model::T ,
                      marked::Array{Int},
                      parameters::Dict{Symbol, X},
                      penalty::U) where {T<:QWalk, X<:Any, U<:Number}
    @assert all(1 <= v <= nv(model.graph) for v=marked) && marked != [] "marked needs to be non-empty subset of graph vertices set"

    check_qss(model, marked, parameters)
    new(model, marked, parameters, penalty)
  end
end

function QSearch(model::T,
                 marked::Array{Int},
                 parameters::Dict{Symbol, S},
                 penalty::U) where {T<:QWalk, S<:Any, U<:Number}
   QSearch{T}(model, marked, parameters, penalty)
end

struct QWalkSimulator{T<:QWalk}
  model::T
  parameters::Dict{Symbol, S} where S

  function QWalkSimulator{T}(model::T,
                             parameters::Dict{Symbol, X}) where {T<:QWalk, X<:Any}
    check_qwalksimulator(model, parameters)
    new(model, parameters)
  end
end

function QWalkSimulator(model::T,
                        parameters::Dict{Symbol, X}) where {T<:QWalk, X<:Any}
  QWalkSimulator{T}(model, parameters)
end

"""
Util functions

"""
graph(qwalk::T where T<:QWalk) = qwalk.graph
graph(qsearch::T where T<:QSearch) = graph(qsearch.model)

marked(qsearch::T where T<:QSearch) = qsearch.marked
model(qsearch::T where T<:QSearch) = qsearch.model
parameters(qsearch::T where T<:QSearch) = qsearch.parameters

"""
Search result

"""
struct QSearchState{S,Y<:Real}
  state::S
  probability::Float64
  time::Y

  function QSearchState{S,Y}(state::S,
                             probability::Float64,
                             runtime::Y) where {S,Y<:Real}
     new(state, probability, runtime)
  end
end

function QSearchState(state::S,
                      probability::Float64,
                      runtime::Y) where {S,Y<:Real}
   QSearchState{S,Y}(state, probability, runtime)
end


function QSearchState(qss::QSearch,
                      state::S,
                      runtime::T) where {S,T<:Real}
   QSearchState{S,T}(state, sum(measure(qss, state, qss.marked)), runtime)
end
