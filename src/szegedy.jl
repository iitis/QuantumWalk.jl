
function szegedy_quantum_search(graph::Graph,
                                marked::Vector{T} where T<:Int,
                                time::Int64)
   #=@assert time >= 0 && "Time needs to be nonnegative"
   @assert marked ⊆ collect(vertices(graph)) "marked needs to be subset of graph vertices set"
   @assert "transistionmatrix" in keys(params) "\"transistionmatrix\" needs to be provided"
   stochastic = params["transistionmatrix"]
   n = nv(graph)
   @assert typeof(stochastic) <: Matrix{T} <: Real "\"transistionmatrix\" needs to be stochastic matrix"
   @assert size(stochastic, 1) == size(stochastic, 2) == n "\"transistionmatrix\" needs to be square matrix of order equal to order of the graph"
   @assert all(sum(P[:,i]) ≈ 1 for i=1:size(P,1)) "\"transistionmatrix\" needs to be stochastic matrix"=#
   1
end
