export
   CTQW

abstract type AbstractCTQW <: ContQWalk end

struct CTQW <: AbstractCTQW
   graph::Graph
   matrix::Symbol
   CTQW(graph::Graph, matrix::Symbol) = matrix ∈ [:adjacency, :laplacian] ? new(graph, matrix) : throw("Only :laplacian and :adjacency is implemented")
end

CTQW(graph::Graph) = CTQW(graph, :adjacency)




# type ContinuousQSpatialSearch{}

function ContQSearch(::Type{T},
                     ctqw::CTQW,
                     marked::Array{Int},
                     jumpingrate::T = jumping_rate(T, ctqw)) where T<:Number
   hamiltonian = jumpingrate*graph_hamlitonian(T, ctqw)
   hamiltonian += sum(proj(T, v, nv(ctqw.graph)) for v=marked)

   parameters = Dict{Symbol, Any}(:hamiltonian => hamiltonian)

   ContQSearch(ctqw, marked, parameters)
end

function ContQSearch(ctqw::CTQW, marked::Array{Int})
   ContQSearch(Complex128, ctqw, marked)
end
function ContQSearch(ctqw::CTQW,
                                  marked::Array{Int},
                                  jumpingrate::T) where T<:Number
   ContQSearch(T, ctqw, marked, jumpingrate)
end


function check_qss(ctqw::CTQW,
                   marked::Array{Int},
                   parameters::Dict{Symbol, Any})
   @assert :hamiltonian ∈ keys(parameters) "parameters needs to have key hamiltonian"
   @assert isa(parameters[:hamiltonian], SparseMatrixCSC{<:Number}) || isa(hamiltonian, Matrix{<:Number}) "value for :hamiltonian needs to be Matrix with numbers"
   @assert size(parameters[:hamiltonian], 1) == size(parameters[:hamiltonian], 2) == nv(ctqw.graph) "Hamiltonian needs to be square matrix of order equal to graph order"
end


include("ctqw_utils.jl")
include("ctqw_evolution.jl")
