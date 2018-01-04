export
   AbstractCTQW,
   CTQW,
   matrix

"""
    AbstractCTQW

Abstract CTQW model. By default evolve according to Schrödinger equation and
performs measurmenet by taking square of absolute values of its elements. Default
representation of `AbstractCTQW` is `CTQW`.
"""
abstract type AbstractCTQW <: ContQWalk end

"""
    CTQW(graph[, matrix])

Default representation of `AbstractCTQW`. `graph` needs to be of type `Graph` from
LightGraphs module, `matrix` needs to be `:adjacency` or `:laplacian` and defaults
to `:adjacency`.
"""
struct CTQW <: AbstractCTQW
   graph::Graph
   matrix::Symbol
   CTQW(graph::Graph, matrix::Symbol) = matrix ∈ [:adjacency, :laplacian] ? new(graph, matrix) : throw("Only :laplacian and :adjacency is implemented")
end

CTQW(graph::Graph) = CTQW(graph, :adjacency)

"""
    matrix(ctqw::AbstractCTQW)

Returns the matrix symbol defining matrix graph used.

```@docs
julia> matrix(CTQW(CompleteGraph(4)))
:adjacency

julia> matrix(CTQW(CompleteGraph(4), :laplacian))
:laplacian
```
"""
matrix(ctqw::AbstractCTQW) = ctqw.matrix

"""
    proj

Return a canonic projection into `i`-th subspace.
 """
function proj(::Type{T}, i::Int, n::Int) where T<:Number
   result = spzeros(T, n, n)
   result[i,i] = 1
   result
end

"""
    check_ctqw(ctqw, parameters)

Private functions which checks the existance of `:hamiltonian`, its type and
dimensionality. Returns nothing.
"""
function check_ctqw(ctqw::AbstractCTQW,
                    parameters::Dict{Symbol})
   @assert :hamiltonian ∈ keys(parameters) "parameters needs to have key hamiltonian"
   @assert isa(parameters[:hamiltonian], SparseMatrixCSC{<:Number}) || isa(hamiltonian, Matrix{<:Number}) "value for :hamiltonian needs to be Matrix with numbers"
   @assert size(parameters[:hamiltonian], 1) == size(parameters[:hamiltonian], 2) == nv(ctqw.graph) "Hamiltonian needs to be square matrix of order equal to graph order"
end

"""
    QSearch([type, ]ctqw::AbstractCTQW, marked [, jumpingrate, penalty])

Creates `QSearch` according to `AbstractCTQW` model. By default `type` equals
`Complex128`, `jumpingrate` equals largest eigenvalue of adjacency matrix of graph if
`matrix(CTQW)` outputs `:adjacency` and error otherwise, and `penalty` equals 0.
By default hamiltonian is `SparseMatrixCSC`.
"""
function QSearch(::Type{T},
                 ctqw::AbstractCTQW,
                 marked::Array{Int},
                 jumpingrate::T = jumping_rate(T, ctqw),
                 penalty::Real = 0. ) where T<:Number
   hamiltonian = jumpingrate*graph_hamiltonian(T, ctqw)
   hamiltonian += sum(proj(T, v, nv(ctqw.graph)) for v=marked)

   parameters = Dict{Symbol,Any}(:hamiltonian => hamiltonian)

   QSearch(ctqw, marked, parameters, penalty)
end

function QSearch(ctqw::AbstractCTQW,
                 marked::Array{Int},
                 jumpingrate::Real = jumping_rate(Float64, ctqw),
                 penalty::Real=0.)
   QSearch(Complex128, ctqw, marked, Complex128(jumpingrate), penalty)
end

"""
    check_qss(ctqw::AbstractCTQW, marked, parameters)

Checks whetver combination of `ctqw`, `marked` and `parameters` produces valid
`QSearch` object. It checks where `parameters` consists of key `:hamiltonian` with
corresponding value being `SparseMatrixCSC` or `Matrix`. Furthermore the hamiltonian
needs to be square of size equals to `graph(ctqw)` order.
"""
function check_qss(ctqw::AbstractCTQW,
                   marked::Array{Int},
                   parameters::Dict{Symbol})
   check_ctqw(ctqw, parameters)
end

"""
    QWalkSimulator([type, ]ctqw::AbstractCTQW)

Creates `QWalkSimulator` according to `AbstractCTQW` model. By default `type` equals
`Complex128`. By default constructed hamiltonian is `SparseMatrixCSC`.
"""
function QWalkSimulator(::Type{U},
                        ctqw::AbstractCTQW) where U<:Number
   parameters = Dict{Symbol,Any}(:hamiltonian => graph_hamiltonian(U, ctqw))
   QWalkSimulator(ctqw, parameters)
end

function QWalkSimulator(ctqw::AbstractCTQW)
   QWalkSimulator(Complex128, ctqw)
end

"""
    check_qwalksimulator(ctqw::AbstractCTQW, parameters)

Checks whetver combination of `ctqw` and `parameters` produces valid
`QSearch` object. It checks where `parameters` consists of key `:hamiltonian` with
corresponding value being `SparseMatrixCSC` or `Matrix`. Furthermore the hamiltonian
needs to be square of size equals to `graph(ctqw)` order.
"""
function check_qwalksimulator(ctqw::AbstractCTQW,
                              parameters::Dict{Symbol})
   check_ctqw(ctqw, parameters)
end

include("ctqw_utils.jl")
include("ctqw_evolution.jl")
