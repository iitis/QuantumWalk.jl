export
   AbstractSzegedy,
   Szegedy

"""
    AbstractSzegedy
"""
abstract type AbstractSzegedy <: DiscrQWalk end

"""
    Szegedy
"""
struct Szegedy{G<:AbstractGraph, T<:Number} <: AbstractSzegedy
   graph::G
   sqrtstochastic::SparseMatrixCSC{T,Int}


   function Szegedy(graph::G,
                    stochastic::SparseMatrixCSC{T},
                    checkstochastic::Bool=true) where {G<:AbstractGraph, T<:Number}
      if checkstochastic
         graphstochasticcheck(g, stochastic)
      end
      new{G, T}(graph, sqrt.(stochastic))
   end
   #=function Szegedy(graph::G,
                    stochastic::SparseMatrixCSC{T}) where {G<:AbstractGraph,T<:Number}
      new{G,T}(graph, sqrt.(stochastic))
   end=#
end



function Szegedy(graph::AbstractGraph)
   Szegedy(graph, default_stochastic(graph), false)
end

function QSearch(szegedy::AbstractSzegedy,
                 marked::Array{Int},
                 penalty::Real=0)
   r1, r2 = szegedywalkoperators(szegedy)
   q1, q2 = szegedyoracleoperators(szegedy, marked)
   parameters = Dict{Symbol,Any}()
   parameters[:operators] = [r1*q1, r2*q2]

   QSearch(szegedy, marked, parameters, penalty)
end

function QWalkSimulator(szegedy::AbstractSzegedy)
   r1, r2 = szegedywalkoperators(szegedy)
   parameters = Dict{Symbol,Any}()
   parameters[:operators] = [r1, r2]

   QWalkSimulator(szegedy, parameters)
end

"""
    check_szegedy
"""
function check_szegedy(szegedy::AbstractSzegedy,
                       parameters::Dict{Symbol})
   @assert :operators in keys(parameters) "Parameters should contain key operators"
   @assert all(typeof(i) <: SparseMatrixCSC{<:Number} for i=parameters[:operators]) "Parameters should be a list of SparseMatrixCSC{<:Number}"
   order = nv(szegedy.graph)
   @assert all(size(i) == (order, order).^2 for i=parameters[:operators]) "Operators sizes mismatch"
end

function check_qss(szegedy::AbstractSzegedy,
                   marked::Array{Int},
                   parameters::Dict{Symbol})
   check_szegedy(szegedy, parameters)
end

function check_qwalksimulator(szegedy::AbstractSzegedy,
                              parameters::Dict{Symbol})
   check_szegedy(szegedy, parameters)
end


include("szegedy_stochastic.jl")
include("szegedy_operators.jl")
include("szegedy_evolution.jl")
