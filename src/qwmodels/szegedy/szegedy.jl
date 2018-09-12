export
   AbstractSzegedy,
   Szegedy,
   sqrtstochastic

"""
    AbstractSzegedy

Type representing the abstract Szegedy model. Description of the default
parameter can be found in https://arxiv.org/abs/1611.02238, where two oracle
operator case is chosen.  Default representation of `AbstractSzegedy` is
`Szegedy`.
"""
abstract type AbstractSzegedy <: QWModelDiscr end

"""
  Szegedy(graph, sqrtstochastic)

Default representation of `AbstractSzegedy`. Parameter `sqrtstochastic` needs to
be an element-wise square root of stochastic matrix.
"""
struct Szegedy{G<:AbstractGraph, T<:Number} <: AbstractSzegedy
    graph::G
    sqrtstochastic::SparseMatrixCSC{T,Int}

    function Szegedy{G, T}(graph::G,
                           sqrtstochastic::SparseMatrixCSC{T}) where {G<:AbstractGraph, T<:Number}
        new{G, T}(graph, sqrtstochastic)
    end
end

"""
    Szegedy(graph[, stochastic, checkstochastic])

Constructors of `AbstractSzegedy`. Parameter `stochastic` needs to be a
stochastic matrix.  Flag `checkstochastic` decides about checking the stochastic
properties.

Matrix `stochastic` defaults to the uniform walk operator, and `checkstochastic`
deafults to `false` in case of default `stochastic`. If matrix `stochastic` is
provided by the user, the default value of `stochastic` is `true`.
"""
function Szegedy(graph::G,
                 stochastic::SparseMatrixCSC{T},
                 checkstochastic::Bool=true) where {G<:AbstractGraph, T<:Number}
    if checkstochastic
        graphstochasticcheck(graph, stochastic)
    end
    Szegedy{G, T}(graph, sqrt.(stochastic))
end,

function Szegedy(graph::AbstractGraph)
    Szegedy(graph, default_stochastic(graph), false)
end

"""
    sqrtstochastic(szegedy)

Returns the `sqrtstochastic` element of `szegedy`.
"""
sqrtstochastic(szegedy::AbstractSzegedy) = szegedy.sqrtstochastic

"""
    QWSearch(szegedy, marked[, penalty])

Creates `QWSearch` according to `AbstractSzegedy` model. By default parameter
`penalty` is set to 0. Evolution operators are constructed according to the
definition from https://arxiv.org/abs/1611.02238.

    QWSearch(qws[; marked, penalty]; check)

Update quantum walk search to new subset of marked elements and new penalty. By
default `marked` and `penalty` are the same as in `qws`.
"""
function QWSearch(szegedy::AbstractSzegedy,
                  marked::Vector{Int},
                  penalty::Real=0)
   walk_operators = szegedy_walk_operators(szegedy)
   oracle_operators = szegedy_oracle_operators(szegedy, marked)
   parameters = Dict{Symbol,Any}()
   parameters[:operators] = walk_operators .* oracle_operators

   QWSearch(szegedy, parameters, marked, penalty)
end

function QWSearch(qws::QWSearch{<:Szegedy};
                  marked::Vector{Int}=qws.marked,
                  penalty::Real=qws.penalty)
   oldmarked = qws.marked
   local corr_oracles
   if Set(marked) != Set(oldmarked)
    corr_oracles = szegedy_oracle_operators(model(qws), oldmarked) .*
                   szegedy_oracle_operators(model(qws), marked)
   else
      corr_oracles = fill(I, length(parameters(qws)[:operators]))#speye.(parameters(qws)[:operators])
   end
   QWSearch(model(qws),
            Dict(:operators => parameters(qws)[:operators].*corr_oracles),
            marked,
            penalty)
end

"""
    QWEvolution(szegedy)

Create `QWEvolution` according to `AbstractSzegedy` model. By default, the
constructed operator is of type `SparseMatrixCSC`.
"""
function QWEvolution(szegedy::AbstractSzegedy)
   parameters = Dict{Symbol,Any}(:operators => szegedy_walk_operators(szegedy))

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
   @assert length(parameters[:operators]) == 2 "Only two operators allowed"
   @assert all(typeof(i) <: AbstractMatrix{<:Number} for i=parameters[:operators]) "Parameters should be a list of SparseMatrixCSC{<:Number}"
   order = nv(szegedy.graph)
   @assert all(size(i) == (order, order).^2 for i=parameters[:operators]) "Operators sizes mismatch"
end

"""
    check_qwdynamics(QWSearch, szegedy, marked, parameters)

Check whetver combination of `szegedy`, `marked` and `parameters` produces valid
`QWSearch` object. It checks where `parameters` consists of key `:operators` with
corresponding value being list of `AbstractMatrix`. Furthermore operators
needs to be square of size equals to square of `graph(szegedy).` order.
"""
function check_qwdynamics(::Type{QWSearch},
                          szegedy::AbstractSzegedy,
                          parameters::Dict{Symbol},
                          marked::Vector{Int})
   check_szegedy(szegedy, parameters)
end

"""
    check_qwdynamics(QWEvolution, szegedy, parameters)

Check whetver combination of `szegedy`, and `parameters` produces a
valid `QWEvolution` object. It checks where `parameters` consists of key
`:operators` with corresponding value being a list of `AbstractMatrix` objects.
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
