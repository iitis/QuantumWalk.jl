export
  QWalk,
  ContQWalk,
  DiscrQWalk,
  QSearch,
  QSearch,
  QSearch,
  graph,
  model,
  marked

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
graph(qwalk::T where T<:QSearch) = graph(qwalk.model)

marked(qwalk::T where T<:QSearch) = qwalk.marked
model(qwalk::T where T<:QSearch) = qwalk.model

"""
Search result

"""
struct QSearchState{S,T<:Real,Y<:Real}
  state::S
  probability::T
  time::Y

  function QSearchState{S,T,Y}(state::S,
                               probability::T,
                               runtime::Y) where {S,T<:Real,Y<:Real}
     new(state, probability, runtime)
  end
end

function QSearchState(state::S,
                      probability::T,
                      runtime::Y) where {S,T<:Real,Y<:Real}
   QSearchState{S,T,Y}(state, probability, runtime)
end


function QSearchState(qss::QSearch,
                      state::S,
                      runtime::T) where {S,T<:Real}
   probability = sum(measure(qss, state, qss.marked))
   QSearchState{S,typeof(probability),T}(state, probability, runtime)
end
