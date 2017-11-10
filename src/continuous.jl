
function continuous_quantum_search(graph::Graph,
                                   marked::Array{T} where T<:Int,
                                   time::Real,
                                   params::Dict{String,T} where T)
   @assert time >= 0 "Time needs to be nonnegative"
   @assert marked ⊆ collect(vertices(graph)) "marked needs to be subset of graph vertices set"
   @assert "jumprate" in keys(params) && typeof(params["jumprate"]) <: Real "\"jumprate\" needs to be provided in params as real number"
   @assert "graphmatrix" in keys(params) "\"graphmatrix\" needs to be provided and needs to be :adjacency or :laplacian"

   graphorder = nv(graph)
   initstate = ones(Complex128, graphorder)/sqrt(graphorder)

   if params["graphmatrix"] == :adjacency
      graphmatrix = adjacency_matrix(graph)
   elseif params["graphmatrix"] == :laplacian
      graphmatrix = laplacian_matrix(graph)
   else
      error("graphmatrix needs to be :adjacency or :laplacian")
   end

   hamiltonian = params["jumprate"] * graphmatrix
   hamiltonian += sum(map(x -> proj(x, graphorder), marked))

   resultstate = expmv(time, -1im*hamiltonian, initstate)
   abs.(resultstate .* conj(resultstate))
end
