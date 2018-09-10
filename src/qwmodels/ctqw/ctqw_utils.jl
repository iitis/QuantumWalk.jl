"""
    jumping_rate([type_number, ]ctqw)

Return default value of the jumping rate for the adjacency matrix. This function
is not implemented for `:laplacian` or `:normalized_laplacian`. For `:adjacency` case the greatest eigenvalue
is returned. By default `type_number` is set to `ComplexF64`.
"""
function jumping_rate(::Type{T}, ctqw::AbstractCTQW) where T<:Number
   @assert ctqw.matrix == :adjacency "Default jumping rate known for adjacency matrix only"

   if ne(ctqw.graph) == 0 # if graph is empty
      return T(1.) #does not matter
   else
      return T(1. /eigs(adjacency_matrix(ctqw.graph), nev=1)[1][1])
   end
end,

function jumping_rate(ctqw::AbstractCTQW)
   jumping_rate(ComplexF64, ctqw)
end


function normalized_laplacian(g::Graph, ::Type{T}) where T<:Number
  l = laplacian_matrix(g, T)
  d = Diagonal(sqrt.(1 ./(diag(l))))
  d*l*d
end


"""
    graph_hamiltonian(type, ctqw)

Returns default evolution matrix of `type`, adjacency, laplacian matrix or normalized laplacian depending on
`ctqw` parametrization.
"""
function graph_hamiltonian(::Type{T}, ctqw::AbstractCTQW) where T<:Number
   if ctqw.matrix == :adjacency
      return -adjacency_matrix(ctqw.graph, T)
   elseif ctqw.matrix == :laplacian
      return laplacian_matrix(ctqw.graph, T)
   elseif ctqw.matrix == :normalized_laplacian
      return normalized_laplacian(ctqw.graph, T)
   else
      throw(ErrorException("Model $ctqw poorly parametrized"))
   end
end
"""
    hamiltonian_evolution(hamiltonian, initstate, runtime)

Evolve `initstate` according to `hamiltonian` for time `runtime` according to
Schrödinger equation. For dense matrices matrix exponantation is calculated. For
sparse matrices `expmv` from `Expokit` package is used.
"""
function hamiltonian_evolution(hamiltonian::AbstractMatrix{<:Number},
                               initstate::Vector{<:Number},
                               runtime::Real)
   exp(-1im*hamiltonian*runtime)*initstate
end

function hamiltonian_evolution(hamiltonian::SparseMatrixCSC{<:Number},
                               initstate::Vector{<:Number},
                               runtime::Real)
   expmv(runtime, -1im*hamiltonian, initstate)
end
