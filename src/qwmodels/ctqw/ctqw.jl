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
abstract type AbstractCTQW <: QWModelCont end

"""
    CTQW(graph, matrix)

Default representation of `AbstractCTQW`. `matrix` defaults
to `:adjacency`. The Hamiltonian is a sparse matrix.
"""
struct CTQW <: AbstractCTQW
   graph::Graph
   matrix::Symbol
   CTQW(graph::Graph, matrix::Symbol) = new(graph, matrix)
end

"""
    CTQWDense(graph, matrix)

Alternative representation of `AbstractCTQW`. `matrix` defaults
to `:adjacency`. The Hamiltonian is a dense matrix.
"""
struct CTQWDense <: AbstractCTQW
   graph::Graph
   matrix::Symbol
   CTQWDense(graph::Graph, matrix::Symbol) = new(graph, matrix)
end

"""
    CTQW(graph)

Constructor for CTQW, taking `matrix` to be `:adjacency`.
"""
CTQW(graph::Graph) = CTQW(graph, :adjacency)

"""
    CTQWDense(graph)

Constructor for CTQWDense, taking `matrix` to be `:adjacency`.
"""
CTQWDense(graph::Graph) = CTQWDense(graph, :adjacency)

"""
    matrix(ctqw)

Returns the matrix symbol defining matrix graph used.
"""
matrix(ctqw::AbstractCTQW) = ctqw.matrix

"""
    proj(type, i, n)

Return a canonic projection onto `i`-th subspace of `n`-dimensional space.
 """
function proj(::Type{T}, i::Int, n::Int) where T<:Number
   result = spzeros(T, n, n)
   result[i,i] = 1
   result
end

"""
    check_ctqw(ctqw, parameters)

Private functions which checks the existance of `:hamiltonian`, its type and
dimensionality.
"""
function check_ctqw(ctqw::AbstractCTQW,
                    parameters::Dict{Symbol})
   @assert :hamiltonian ∈ keys(parameters) "parameters needs to have key hamiltonian"
   @assert isa(parameters[:hamiltonian], AbstractMatrix{<:Number}) "value for :hamiltonian needs to be Matrix with numbers"
   @assert size(parameters[:hamiltonian], 1) == size(parameters[:hamiltonian], 2) == nv(ctqw.graph) "Hamiltonian needs to be square matrix of order equal to graph order"
   nothing
end,

function check_ctqw(ctqw::CTQWDense,
                    parameters::Dict{Symbol})
   @assert :hamiltonian ∈ keys(parameters) "parameters needs to have key hamiltonian"
   @assert isa(parameters[:hamiltonian], DenseMatrix{<:Number}) "value for :hamiltonian needs to be Matrix with numbers"
   @assert size(parameters[:hamiltonian], 1) == size(parameters[:hamiltonian], 2) == nv(ctqw.graph) "Hamiltonian needs to be square matrix of order equal to graph order"
   nothing
end


"""
    QWSearch([type, ]ctqw, marked[, penalty, jumpingrate])

Creates `QWSearch` according to `AbstractCTQW` model. By default `type` equals
`ComplexF64`, `jumpingrate` equals largest eigenvalue of adjacency matrix of graph if
`matrix(CTQW)` outputs `:adjacency` and error otherwise, and `penalty` equals 0.

    QWSearch(qws_ctqw; marked, penalty)

Updates quantum walk search to new subset of marked elements and new penalty. By
default marked and penalty are the same as in qws.
"""
function QWSearch(::Type{T},
                  ctqw::AbstractCTQW,
                  marked::Vector{Int},
                  penalty::Real = 0.,
                  jumpingrate::T = jumping_rate(T, ctqw)) where T<:Number

   hamiltonian = jumpingrate*graph_hamiltonian(T, ctqw)
   hamiltonian -= sum(proj(T, v, nv(ctqw.graph)) for v=marked)

   parameters = Dict{Symbol,Any}(:hamiltonian => hamiltonian)

   QWSearch(ctqw, parameters, marked, penalty)
end,

function QWSearch(::Type{T},
                  ctqw::CTQWDense,
                  marked::Vector{Int},
                  penalty::Real = 0.,
                  jumpingrate::T = jumping_rate(T, ctqw)) where T<:Number

   hamiltonian = jumpingrate*Matrix(graph_hamiltonian(T, ctqw))
   hamiltonian -= sum(proj(T, v, nv(ctqw.graph)) for v=marked)

   parameters = Dict{Symbol,Any}(:hamiltonian => hamiltonian)

   QWSearch(ctqw, parameters, marked, penalty)
end,

function QWSearch(ctqw::AbstractCTQW,
                  marked::Vector{Int},
                  penalty::Real = 0.,
                  jumpingrate::Real = jumping_rate(Float64, ctqw))
   QWSearch(ComplexF64, ctqw, marked, penalty, ComplexF64(jumpingrate))
end,

function QWSearch(qws::QWSearch{<:AbstractCTQW};
                  marked::Vector{Int}=qws.marked,
                  penalty::Real=qws.penalty)
   oldmarked = qws.marked

   hamiltonian = copy(parameters(qws)[:hamiltonian])
   hamiltonian -= sum(proj(eltype(hamiltonian), v, nv(graph(qws))) for v=marked)
   hamiltonian += sum(proj(eltype(hamiltonian), v, nv(graph(qws))) for v=oldmarked)

   QWSearch(model(qws), Dict(:hamiltonian => hamiltonian), marked, penalty)
end



"""
    check_qwdynamics(QWSearch, ctqw, parameters, marked)

Checks whetver combination of `ctqw`, `marked` and `parameters` produces valid
`QWSearch` object. It checks if `parameters` consists of key `:hamiltonian` with
real-valued matrix. Furthermore the hamiltonian
needs to be square of size equals to `graph(ctqw)` order. the hermiticity is
not checked for efficiency issue.
"""
function check_qwdynamics(::Type{QWSearch},
                          ctqw::AbstractCTQW,
                          parameters::Dict{Symbol},
                          marked::Vector{Int})
   check_ctqw(ctqw, parameters)
end

"""
    QWEvolution([type_ctqw, ]ctqw)

Creates `QWEvolution` according to `AbstractCTQW` model. By default `type` equals
`ComplexF64`.
"""
function QWEvolution(::Type{U},
                     ctqw::AbstractCTQW) where U<:Number
   parameters = Dict{Symbol,Any}(:hamiltonian => graph_hamiltonian(U, ctqw))
   QWEvolution(ctqw, parameters)
end,

function QWEvolution(ctqw::AbstractCTQW)
   QWEvolution(ComplexF64, ctqw)
end

"""
    check_qwdynamics(QWEvolution, ctqw, parameters)

Checks if combination of `ctqw` and `parameters` produces valid
`QWSearch` object. It checks if `parameters` consists of key `:hamiltonian` with
real-valued matrix. Furthermore the hamiltonian
needs to be square of size equals to `graph(ctqw)` order. The hermiticity is
not checked for efficiency issues.
"""
function check_qwdynamics(::Type{QWEvolution},
                          ctqw::AbstractCTQW,
                          parameters::Dict{Symbol})
   check_ctqw(ctqw, parameters)
end

include("ctqw_utils.jl")
include("ctqw_evolution.jl")
