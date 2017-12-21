export
   AbstractCTQW,
   CTQW

"""
    AbstractCTQW
"""
abstract type AbstractCTQW <: ContQWalk end

"""
    CTQW
"""
struct CTQW <: AbstractCTQW
   graph::Graph
   matrix::Symbol
   CTQW(graph::Graph, matrix::Symbol) = matrix ∈ [:adjacency, :laplacian] ? new(graph, matrix) : throw("Only :laplacian and :adjacency is implemented")
end

CTQW(graph::Graph) = CTQW(graph, :adjacency)

"""
    proj
"""
function proj(::Type{T}, i::Int, n::Int) where T<:Number
   result = spzeros(T, n, n)
   result[i,i] = 1
   result
end

# type ContinuousQSpatialSearch{}
"""
    check_ctqw
"""
function check_ctqw(ctqw::U where U<:AbstractCTQW,
                    parameters::Dict{Symbol, Any})
   @assert :hamiltonian ∈ keys(parameters) "parameters needs to have key hamiltonian"
   @assert isa(parameters[:hamiltonian], SparseMatrixCSC{<:Number}) || isa(hamiltonian, Matrix{<:Number}) "value for :hamiltonian needs to be Matrix with numbers"
   @assert size(parameters[:hamiltonian], 1) == size(parameters[:hamiltonian], 2) == nv(ctqw.graph) "Hamiltonian needs to be square matrix of order equal to graph order"
end

function QSearch(::Type{T},
                 ctqw::U where U<:AbstractCTQW,
                 marked::Array{Int},
                 jumpingrate::T = jumping_rate(T, ctqw),
                 penalty::S where S<:Real = 0. ) where T<:Number
   hamiltonian = jumpingrate*graph_hamlitonian(T, ctqw)
   hamiltonian += sum(proj(T, v, nv(ctqw.graph)) for v=marked)

   parameters = Dict{Symbol, Any}(:hamiltonian => hamiltonian)

   QSearch(ctqw, marked, parameters, penalty)
end

function QSearch(ctqw::T where T<:AbstractCTQW,
                 marked::Array{Int},
                 jumpingrate::U = jumping_rate(Float64, ctqw),
                 penalty::S where S<:Real=0.) where U<:Real
   QSearch(Complex128, ctqw, marked, Complex128(jumpingrate), penalty)
end

function check_qss(ctqw::U where U<:AbstractCTQW,
                   marked::Array{Int},
                   parameters::Dict{Symbol, Any})
   check_ctqw(ctqw, parameters)
end

function QWalkSimulator(::Type{U},
                        ctqw::T where T<:AbstractCTQW) where U<:Number
   parameters = Dict{Symbol, Any}(:hamiltonian => graph_hamlitonian(U, ctqw))
   QWalkSimulator(ctqw, parameters)
end

function QWalkSimulator(ctqw::T where T<:AbstractCTQW)
   QWalkSimulator(Complex128, ctqw)
end

function check_qwalksimulator(ctqw::U where U<:AbstractCTQW,
                              parameters::Dict{Symbol, Any})
   check_ctqw(ctqw, parameters)
end

include("ctqw_utils.jl")
include("ctqw_evolution.jl")
