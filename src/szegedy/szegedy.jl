export
   AbstractSzegedy,
   Szegedy,
   sqrtstochastic

"""
    AbstractSzegedy

Abstract Szegedy model. Description of the default parameter can be found in
https://arxiv.org/abs/1611.02238, where two oracle operator case is chosen.
Default representation of `AbstractSzegedy` is `Szegedy`.
"""
abstract type AbstractSzegedy <: QWModelDiscr end

"""
    Szegedy(graph[, stochastic, checkstochastic])

 Default representation of `AbstractSzegedy`. Parameter `graph` needs to be a
 subtype of `AbstractGraph` from LightGraphs module, and parameter `stochastic`
 needs to be a Real column stochastic matrix. Flag `checkstochastic` decides
 about checking the stochastic properties.

 Matrix `stochastic` defaults to the uniform walk operator, and
 `checkstochastic` deafults to `false` in case of default `stochastic`. If
 matrix `stochastic` is provided by the user, the default value of `stochastic`
 is true.

 Matrix `stochastic` is changed into `sqrtstochastic` by taking element-wise
 square root.
"""
struct Szegedy{G<:AbstractGraph, T<:Number} <: AbstractSzegedy
   graph::G
   sqrtstochastic::SparseMatrixCSC{T,Int}

   function Szegedy{G, T}(graph::G,
                          sqrtstochastic::SparseMatrixCSC{T}) where {G<:AbstractGraph, T<:Number}
      new{G, T}(graph, sqrtstochastic)
   end

end

function Szegedy(graph::G,
                 stochastic::SparseMatrixCSC{T},
                 checkstochastic::Bool=true) where {G<:AbstractGraph, T<:Number}
   if checkstochastic
      graphstochasticcheck(graph, stochastic)
   end
   Szegedy{G, T}(graph, sqrt.(stochastic))
end

function Szegedy(graph::AbstractGraph)
   Szegedy(graph, default_stochastic(graph), false)
end

"""
    sqrtstochastic(szegedy)

Return the `sqrtstochastic` element of `szegedy`. After element-wise squaring a
column-stochastic matrix is obtained.

```jldoctest
julia> szegedy = Szegedy(CompleteGraph(4));

julia> sqrtstochastic(szegedy)
4×4 SparseMatrixCSC{Float64,Int64} with 12 stored entries:
  [2, 1]  =  0.57735
  [3, 1]  =  0.57735
  [4, 1]  =  0.57735
  [1, 2]  =  0.57735
  [3, 2]  =  0.57735
  [4, 2]  =  0.57735
  [1, 3]  =  0.57735
  [2, 3]  =  0.57735
  [4, 3]  =  0.57735
  [1, 4]  =  0.57735
  [2, 4]  =  0.57735
  [3, 4]  =  0.57735

julia> full(sqrtstochastic(szegedy).^2)
4×4 Array{Float64,2}:
 0.0       0.333333  0.333333  0.333333
 0.333333  0.0       0.333333  0.333333
 0.333333  0.333333  0.0       0.333333
 0.333333  0.333333  0.333333  0.0
```
"""
sqrtstochastic(szegedy::AbstractSzegedy) = szegedy.sqrtstochastic

"""
    QWSearch(szegedy::AbstractSzegedy, marked [, penalty])

Creates `QWSearch` according to `AbstractSzegedy` model. By default parameter
`penalty` is set to 0. Evolution operators are constructed according to the
definition from https://arxiv.org/abs/1611.02238.
"""
function QWSearch(szegedy::AbstractSzegedy,
                  marked::Array{Int},
                  penalty::Real=0)
   r1, r2 = szegedy_walk_operators(szegedy)
   q1, q2 = szegedyoracleoperators(szegedy, marked)
   parameters = Dict{Symbol,Any}()
   parameters[:operators] = [r1*q1, r2*q2]

   QWSearch(szegedy, marked, parameters, penalty)
end

"""
    QWSearch(qss::QWSearch[; marked , penalty])

Update quantum walk search to new subset of marked elements and new penalty. By
default `marked` and `penalty` are the same as in `qss`.

"""
function QWSearch(qss::QWSearch{<:Szegedy};
                  marked::Vector{Int}=qss.marked,
                  penalty::Real=qss.penalty)
   oldmarked = qss.marked
   local corr_oracles
   if Set(marked) != Set(oldmarked)
    corr_oracles = szegedyoracleoperators(model(qss), oldmarked) .*
                   szegedyoracleoperators(model(qss), marked)
   else
      corr_oracles = speye.(parameters(qss)[:operators])
   end
   QWSearch(model(qss),
            marked,
            Dict(:operators => parameters(qss)[:operators].*corr_oracles),
            penalty)
end

"""
    QWEvolution(szegedy::AbstractSzegedy)

Create `QWEvolution` according to `AbstractSzegedy` model. By default, the
constructed operator is of type `SparseMatrixCSC`.
"""
function QWEvolution(szegedy::AbstractSzegedy)
   r1, r2 = szegedy_walk_operators(szegedy)
   parameters = Dict{Symbol,Any}()
   parameters[:operators] = [r1, r2]

   QWEvolution(szegedy, parameters)
end

"""
    check_szegedy(szegedy, parameters)

Private function for checking the existance of `:operators`, its type, and the
dimensionality of its elements.
"""
function check_szegedy(szegedy::AbstractSzegedy,
                       parameters::Dict{Symbol})
   @assert :operators in keys(parameters) "Parameters should contain key operators"
   @assert all(typeof(i) <: SparseMatrixCSC{<:Number} for i=parameters[:operators]) "Parameters should be a list of SparseMatrixCSC{<:Number}"
   order = nv(szegedy.graph)
   @assert all(size(i) == (order, order).^2 for i=parameters[:operators]) "Operators sizes mismatch"
end

"""
    check_qwdynamics(szegedy::AbstractSzegedy, marked, parameters)

Check whetver combination of `szegedy`, `marked` and `parameters` produces valid
`QWSearch` object. It checks where `parameters` consists of key `:operators` with
corresponding value being list of `SparseMatrixCSC`. Furthermore operators
needs to be square of size equals to square of `graph(szegedy).` order.
"""
function check_qwdynamics(::Type{QWSearch},
                          szegedy::AbstractSzegedy,
                          marked::Array{Int},
                          parameters::Dict{Symbol})
   check_szegedy(szegedy, parameters)
end

"""
    check_qwdynamics(szegedy::AbstractSzegedy, marked, parameters)

Check whetver combination of `szegedy`, `marked` and `parameters` produces a
valid `QWEvolution` object. It checks where `parameters` consists of key
`:operators` with corresponding value being a list of `SparseMatrixCSC` objects.
Furthermore operators need to be square of size equals to square of the order of
`graph(szegedy)`.
"""
function check_qwdynamics(::Type{QWEvolution},
                          szegedy::AbstractSzegedy,
                          parameters::Dict{Symbol})
   check_szegedy(szegedy, parameters)
end

include("szegedy_stochastic.jl")
include("szegedy_operators.jl")
include("szegedy_evolution.jl")
