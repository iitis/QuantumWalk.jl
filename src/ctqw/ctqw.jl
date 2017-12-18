export
   AbstractCTQW,
   CTQW

abstract type AbstractCTQW <: ContQWalk end

struct CTQW <: AbstractCTQW
   graph::Graph
   matrix::Symbol
   CTQW(graph::Graph, matrix::Symbol) = matrix ∈ [:adjacency, :laplacian] ? new(graph, matrix) : throw("Only :laplacian and :adjacency is implemented")
end

CTQW(graph::Graph) = CTQW(graph, :adjacency)


function proj(::Type{T}, i::Int, n::Int) where T<:Number
   result = spzeros(T, n, n)
   result[i,i] = 1
   result
end

# type ContinuousQSpatialSearch{}

function QSearch(::Type{T},
                     ctqw::U,
                     marked::Array{Int},
                     jumpingrate::T = jumping_rate(T, ctqw)) where {U<:AbstractCTQW,T<:Number}
   hamiltonian = jumpingrate*graph_hamlitonian(T, ctqw)
   hamiltonian += sum(proj(T, v, nv(ctqw.graph)) for v=marked)

   parameters = Dict{Symbol, Any}(:hamiltonian => hamiltonian)

   QSearch(ctqw, marked, parameters)
end

function QSearch(ctqw::U, marked::Array{Int}) where U<:AbstractCTQW
   QSearch(Complex128, ctqw, marked)
end
function QSearch(ctqw::T,
                     marked::Array{Int},
                     jumpingrate::U) where {T<:AbstractCTQW,U<:Number}
   QSearch(T, ctqw, marked, jumpingrate)
end


function check_qss(ctqw::U,
                   marked::Array{Int},
                   parameters::Dict{Symbol, Any}) where U<:AbstractCTQW
   @assert :hamiltonian ∈ keys(parameters) "parameters needs to have key hamiltonian"
   @assert isa(parameters[:hamiltonian], SparseMatrixCSC{<:Number}) || isa(hamiltonian, Matrix{<:Number}) "value for :hamiltonian needs to be Matrix with numbers"
   @assert size(parameters[:hamiltonian], 1) == size(parameters[:hamiltonian], 2) == nv(ctqw.graph) "Hamiltonian needs to be square matrix of order equal to graph order"
end


include("ctqw_utils.jl")
include("ctqw_evolution.jl")
