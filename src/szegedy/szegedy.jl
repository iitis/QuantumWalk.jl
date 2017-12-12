export
   AbstractSzegedy,
   Szegedy

abstract type AbstractSzegedy <: DiscrQWalk end

struct Szegedy{G<:AbstractGraph, T<:Real} <: AbstractSzegedy
   graph::G
   sqrtstochastic::SparseMatrixCSC{T,Int}

   function Szegedy{G,T}(graph::G,
                         stochastic::SparseMatrixCSC{T}) where {G<:AbstractGraph, T<:Real}
      new(graph, sqrt.(stochastic))
   end
end

function Szegedy(graph::G,
                 stochastic::SparseMatrixCSC{T},
                 checkstochastic::Bool=true) where {G<:AbstractGraph, T<:Real}
   if checkstochastic
      isgraphstochastic(stochastic)
   end
   Szegedy{G, T}(graph, stochastic)
end

function Szegedy(graph::G) where G<:AbstractGraph
   Szegedy(graph, default_stochastic(graph), false)
end

function QSearch(szegedy::U where U<:AbstractSzegedy,
                 marked::Array{Int})
   r1, r2 = szegedywalkoperators(szegedy)
   q1, q2 = szegedyoracleoperators(szegedy, marked)
   parameters = Dict{Symbol,Any}()
   parameters[:operators] = [r1*q1, r2*q2]

   QSearch(szegedy, marked, parameters)
end


function check_qss(szegedy::T where T<:AbstractSzegedy,
                   marked::Array{Int},
                   parameters::Dict{Symbol, Any})
   @assert :operators in keys(parameters) "Parameters should contain key operators"
   @assert all(typeof(i) <: SparseMatrixCSC{<:Number} for i=parameters[:operators]) "Parameters should be a list of SparseMatrixCSC{<:Number}"
   order = nv(szegedy.graph)
   @assert all(size(i) == (order, order).^2 for i=parameters[:operators]) "Operators sizes mismatch"
end



#Copy to discrete_search and remove
function szegedy_update_results!(result::SparseMatrixCSC{T} where T<:Real,
                                 state::SparseVector{T} where T<:Real,
                                 currenttime::Int,
                                 measure::Bool)
   if measure
      result[:,currenttime+1] = szegedymeasurement(state)
   else
      result[:,currenttime+1] = state
   end
   nothing
end

function szegedy_prepare_for_results(graph::T where T<:AbstractGraph,
                                     time::Int,
                                     all::Bool,
                                     measure::Bool)
   if measure
      data_size = nv(graph)
   else
      data_size = nv(graph)^2
   end

   if all
      zeros(data_size, time+1)
   else
      zeros(data_size)
   end
end

function szegedy_maximal_probability(graph::T where T<:Union{Graph,DiGraph},
                                     marked::Vector{Int},
                                     mode::Symbol=:firstmaxprob;
                                     tmax::Int = nv(graph),
                                     stochastic::SparseMatrixCSC{S, Int}
                                             = default_stochastic(graph),
                                     checkstochastic::Bool = false) where S<:Real
   @assert tmax >= 0 "Time needs to be  nonnegative"
   @assert marked ⊆ collect(vertices(graph)) && marked != [] "marked needs to be non-empty subset of graph vertices set"

   if checkstochastic
      isgraphstochastic(graph, stochastic)
   end

   sqrtstochastic::SparseMatrixCSC{Float64,Int} = sqrt.(stochastic)

   r1, r2 = szegedywalkoperators(sqrtstochastic)
   q1, q2 = szegedyoracleoperators(graph, marked)
   w1 = r1*q1
   w2 = r2*q2

   state = szegedyinitialstate(sqrtstochastic)

   best_probability = sum(szegedymeasurement(state, marked))

   result = Dict{Symbol, Any}()
   result[:state] = state
   result[:probability] = best_probability
   result[:step] = 0


   for t = 1:tmax
      state = w2*(w1*state)
      if !_continue_szegedy_maxprob_update!(result, state, t, marked, mode, tmax)
         break
      end
   end

   result
end

function _szegedy_update!(result::Dict{Symbol, Any},
                          state::SparseVector{T} where T<:Number,
                          probability::Real,
                          time::Int)
   result[:state] = state
   result[:step] = time
   result[:probability] = probability
end


function _szegedy_maxprob_update_firstmaxprob!(result::Dict{Symbol, Any},
                                          state::SparseVector{T} where T<:Number,
                                          time::Int,
                                          marked::Vector{Int})

   new_probability = sum(szegedymeasurement(state, marked))
   if  new_probability > result[:probability]
      _szegedy_update!(result, state, new_probability, time)
      return true
   end
   return false
end

function _szegedy_maxprob_update_maxeff!(result::Dict{Symbol, Any},
                                         state::SparseVector{T} where T<:Number,
                                         time::Int,
                                         marked::Vector{Int})

   new_probability = sum(szegedymeasurement(state, marked))
   new_efficiency = time/new_probability

   if result[:step] == 0 || new_efficiency < result[:step]/result[:probability]
      _szegedy_update!(result, state, new_probability, time)
      return true
   end

   if result[:step]/result[:probability] >= time
      return true
   else
      return false
   end
end

function _szegedy_maxprob_update_firstmaxeff!(result::Dict{Symbol, Any},
                                          state::SparseVector{T} where T<:Number,
                                          time::Int,
                                          marked::Vector{Int})

   new_probability = sum(szegedymeasurement(state, marked))
   new_efficiency = time/new_probability

   if result[:step] == 0 || new_efficiency < result[:step]/result[:probability]
      _szegedy_update!(result, state, new_probability, time)
      return true
   end
   return false
end


function _szegedy_maxprob_update_tmax!(result::Dict{Symbol, Any},
                                       state::SparseVector{T} where T<:Number,
                                       time::Int,
                                       marked::Vector{Int},
                                       tmax::Int)
   new_probability = sum(szegedymeasurement(state, marked))
   new_efficiency = time/new_probability
   if  result[:step] == 0 || new_efficiency < result[:step]/result[:probability]
      _szegedy_update!(result, state, new_probability, time)
   end
   return time != tmax
end


function _continue_szegedy_maxprob_update!(result::Dict{Symbol, Any},
                                           state::SparseVector{T} where T<:Number,
                                           time::Int,
                                           marked::Vector{Int},
                                           mode::Symbol,
                                           tmax::Int)
   @assert mode ∈ [:firstmaxprob, :firstmaxeff, :maxtime, :maxeff] "Mode needs to be :firstmax, :firstmaxeff or :maxtime"

   if mode == :firstmaxprob
      return _szegedy_maxprob_update_firstmaxprob!(result, state, time, marked)
   elseif mode == :firstmaxeff
      return _szegedy_maxprob_update_firstmaxeff!(result, state, time, marked)
   elseif mode == :maxeff
      return _szegedy_maxprob_update_maxeff!(result, state, time, marked)
   elseif mode == :maxtime
      return _szegedy_maxprob_update_tmax!(result, state, time, marked, tmax)
   end
   return false #never happens
end


include("szegedy_stochastic.jl")
include("szegedy_operators.jl")
include("szegedy_evolution.jl")
