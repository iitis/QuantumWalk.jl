"""
    jumping_rate
"""
function jumping_rate(::Type{T}, ctqw::S where S<:AbstractCTQW) where T<:Number
   @assert ctqw.matrix == :adjacency "Default jumping rate known for adjacency matrix only"

   if ne(ctqw.graph) == 0 # if graph is empty
      return T(1.) #does not matter
   else
      return T(1./eigs(adjacency_matrix(ctqw.graph), nev=1)[1][1])
   end
end

jumping_rate(ctqw::S where S<:AbstractCTQW) = jumping_rate(Complex128, ctqw)

"""
    graph_hamlitonian
"""
function graph_hamlitonian(::Type{T},
                           ctqw::S where S<:AbstractCTQW) where T<:Number
   if ctqw.matrix == :adjacency
      return adjacency_matrix(ctqw.graph, T)
   elseif ctqw.matrix == :laplacian
      return laplacian_matrix(ctqw.graph, T)
   else
      throw(ErrorException("Something wrong with model: $ctqw"))
   end
end

graph_hamlitonian(ctqw::S where S<:AbstractCTQW) = graph_hamlitonian(Complex128, ctqw)

"""
    hamiltonian_evolution
"""
function hamiltonian_evolution(hamiltonian::DenseMatrix{T} where T<:Number,
                               initstate::Array{U} where U<:Number,
                               time::S where S<:Real)
   expm(1im*hamiltonian*time)*initstate
end


function hamiltonian_evolution(hamiltonian::SparseMatrixCSC{T} where T<:Number,
                               initstate::Array{U} where U<:Number,
                               time::S where S<:Real)
   expmv(time, 1im*hamiltonian, initstate)
end
