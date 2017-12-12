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

include("szegedy_stochastic.jl")
include("szegedy_operators.jl")
include("szegedy_evolution.jl")
