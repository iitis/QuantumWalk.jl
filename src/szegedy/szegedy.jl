export
   AbstractSzegedy,
   Szegedy,
   sqrtstochastic

"""
    AbstractSzegedy

Abstract Szegedy model. Description of default can be found in
https://arxiv.org/abs/1611.02238, where two oracle operator case is chosen. Default
representation of `AbstractSzegedy` is `Szegedy`.
"""
abstract type AbstractSzegedy <: QWModelDiscr end

"""
    Szegedy(graph[, stochastic, checkstochastic])

 Default representation of `AbstractSzegedy`. `graph` needs to be a subtype of
 `AbstractGraph` from
 LightGraphs module, `stochastic` needs to be a Real column stochastic matrix,
 checkstochastic is a flag which decides about checking the `stochastic` properties.
 `stochastic` defaults to uniform walk operator, `checkstochastic` deafults to `false`
 in case of default `stochastic` and `false` in case of user `stochastic` provided.

 `stochatsic` is changed into `sqrtstochastic` by element-wise square root.
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
end

function Szegedy(graph::AbstractGraph)
   Szegedy(graph, default_stochastic(graph), false)
end

"""
    sqrtstochastic(szegedy::AbstractSzegedy)

Returns the `sqrtstochastic` element of `szegedy`. After element-wise squaring
a column-stochastic matrix is obtained.

```@docs
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

Creates `QWSearch` according to `AbstractSzegedy` model. `penalty` equals 0.
It constructs evolution operators according to definition from
https://arxiv.org/abs/1611.02238.
"""
function QWSearch(szegedy::AbstractSzegedy,
                 marked::Array{Int},
                 penalty::Real=0)
   r1, r2 = szegedywalkoperators(szegedy)
   q1, q2 = szegedyoracleoperators(szegedy, marked)
   parameters = Dict{Symbol,Any}()
   parameters[:operators] = [r1*q1, r2*q2]

   QWSearch(szegedy, marked, parameters, penalty)
end

"""
    QWEvolution(szegedy::AbstractSzegedy)

Creates `QWEvolution` according to `AbstractSzegedy` model. By default
constructed operators is `SparseMatrixCSC`.
"""
function QWEvolution(szegedy::AbstractSzegedy)
   r1, r2 = szegedywalkoperators(szegedy)
   parameters = Dict{Symbol,Any}()
   parameters[:operators] = [r1, r2]

   QWEvolution(szegedy, parameters)
end

"""
    check_szegedy(szegedy, parameters)

Private functions which checks the existance of `:operators`, its type and
dimensionality of its elements. Returns nothing.
"""
function check_szegedy(szegedy::AbstractSzegedy,
                       parameters::Dict{Symbol})
   @assert :operators in keys(parameters) "Parameters should contain key operators"
   @assert all(typeof(i) <: SparseMatrixCSC{<:Number} for i=parameters[:operators]) "Parameters should be a list of SparseMatrixCSC{<:Number}"
   order = nv(szegedy.graph)
   @assert all(size(i) == (order, order).^2 for i=parameters[:operators]) "Operators sizes mismatch"
end

"""
    check_qss(szegedy::AbstractSzegedy, marked, parameters)

Checks whetver combination of `szegedy`, `marked` and `parameters` produces valid
`QWSearch` object. It checks where `parameters` consists of key `:operators` with
corresponding value being list of `SparseMatrixCSC`. Furthermore operators
needs to be square of size equals to square of `graph(szegedy).` order.
"""
function check_qss(szegedy::AbstractSzegedy,
                   marked::Array{Int},
                   parameters::Dict{Symbol})
   check_szegedy(szegedy, parameters)
end

"""
    check_qwalksimulator(szegedy::AbstractSzegedy, marked, parameters)

Checks whetver combination of `szegedy`, `marked` and `parameters` produces valid
`QWEvolution` object. It checks where `parameters` consists of key `:operators` with
corresponding value being list of `SparseMatrixCSC`. Furthermore operators
needs to be square of size equals to square of `graph(szegedy).` order.
"""
function check_qwalksimulator(szegedy::AbstractSzegedy,
                              parameters::Dict{Symbol})
   check_szegedy(szegedy, parameters)
end


include("szegedy_stochastic.jl")
include("szegedy_operators.jl")
include("szegedy_evolution.jl")
