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
                 jumpingrate::T = jumping_rate(T, ctqw),
                 penalty::S = 0.) where {U<:AbstractCTQW,T<:Number,S<:Number}
   hamiltonian = jumpingrate*graph_hamlitonian(T, ctqw)
   hamiltonian += sum(proj(T, v, nv(ctqw.graph)) for v=marked)

   parameters = Dict{Symbol, Any}(:hamiltonian => hamiltonian)

   QSearch(ctqw, marked, parameters, penalty)
end

function QSearch(ctqw::T,
                 marked::Array{Int},
                 jumpingrate::U = jumping_rate(Float64, ctqw),
                 penalty::S=0.) where {T<:AbstractCTQW,U<:Number,S<:Number}
   QSearch(U, ctqw, marked, jumpingrate, penalty)
end


function check_qss(ctqw::U,
                   marked::Array{Int},
                   parameters::Dict{Symbol, Any}) where U<:AbstractCTQW
   check_qwalksimulator(ctqw, parameters)
end

function QWalkSimulator(::Type{U}, ctqw::T) where {U<:Number,T<:AbstractCTQW}
   parameters = Dict{Symbol, Any}(:hamiltonian => graph_hamlitonian(U, ctqw))
   QWalkSimulator(ctqw, parameters)
end


function QWalkSimulator(ctqw::T) where T<:AbstractCTQW
   QWalkSimulator(Complex128, ctqw)
end

function check_qwalksimulator(ctqw::U,
                              parameters::Dict{Symbol, Any}) where U<:AbstractCTQW
   @assert :hamiltonian ∈ keys(parameters) "parameters needs to have key hamiltonian"
   @assert isa(parameters[:hamiltonian], SparseMatrixCSC{<:Number}) || isa(hamiltonian, Matrix{<:Number}) "value for :hamiltonian needs to be Matrix with numbers"
   @assert size(parameters[:hamiltonian], 1) == size(parameters[:hamiltonian], 2) == nv(ctqw.graph) "Hamiltonian needs to be square matrix of order equal to graph order"
end

include("ctqw_utils.jl")

include("ctqw_evolution.jl")
