export
  QWalk,
  ContQWalk,
  DiscrQWalk,
  QSearch,
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

  function QSearch{T}(model::T ,
                      marked::Array{Int},
                      parameters::Dict{Symbol, U}) where {T<:QWalk, U<:Any}
    @assert all(1 <= v <= nv(model.graph) for v=marked) && marked != [] "marked needs to be non-empty subset of graph vertices set"

    check_qss(model, marked, parameters)
    new(model, marked, parameters)
  end
end

function QSearch(model::T,
                 marked::Array{Int},
                 parameters::Dict{Symbol, S}) where {T<:QWalk, S<:Any}
   QSearch{T}(model, marked, parameters)
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
