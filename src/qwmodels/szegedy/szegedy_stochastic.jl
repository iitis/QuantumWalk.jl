"""
    outneighbors_looped(graph, vertex)

Return lists of outneighbors of `vertex` in `graph`. If outdegree of `vertex` is
zero, then [v] is returned.
"""
function outneighbors_looped(graph::AbstractGraph, vertex::Int)
   outns = outneighbors(graph, vertex)
   if outns == []
      return [vertex]
   end
   outns
end


"""
    isstochastic(stochastic)

Checks whether `stochastic` is column-stochastic matrix. Returns nothing.
"""
function stochasticcheck(stochastic::SparseMatrixCSC{<:Number})
   @assert size(stochastic, 1) == size(stochastic, 2) "Matrix is not square"
   @assert all(sum(stochastic[:,i]) ≈ 1 for i=1:size(stochastic, 1)) "Columns sums do not equal one"
   @assert all(findnz(stochastic)[3] .> 0 ) "Matrix elements are not nonnegative"
   nothing
end


"""
    stochastic_preserves_graph_check(graph, stochastic)

Checks whether `stochastic` matrix presreves graph structure. Returns nothing.
"""
function graphpreservationcheck(graph::AbstractGraph,
                                stochastic::SparseMatrixCSC{<:Number})
   @assert size(stochastic, 1) == nv(graph) "Orders of matrix and graph do not match"
   @assert all([ i ∈ outneighbors_looped(graph, j) for (i, j, _)=zip(findnz(stochastic)...)]) "Nonzero elements of stochastic do not coincide with graph edges"
   nothing
end

"""
    graphstochasticcheck(graph, stochastic)

Check, whether `stochastic` is a column-stochatsic matrix preserving `graph`
structure. Three properties are verified:
* `stochastic` is column-stochastic matrix,
* nonzero element of `stochastic` are located on edges of `graph`.

Function returns `nothing` if `stochastic` satisfies properties above, otherwise
raise error.
"""
function graphstochasticcheck(graph::AbstractGraph,
                              stochastic::SparseMatrixCSC{<:Number})
   stochasticcheck(stochastic)
   graphpreservationcheck(graph, stochastic)
   nothing
end

"""
    default_stochastic(graph)

Generates default column-stochastic matrix, which represents random walk with
uniform spreading. If outdegree of vertex is zero, additional 1 is added on the
diagonal.
"""
function default_stochastic(graph::AbstractGraph)
   result = adjacency_matrix(graph, Float64, dir=:in)
   outdegrees = outdegree(graph)
   for i = 1:size(result, 1)
      if outdegrees[i] == 0
         result[i,i] = 1.
      else
         result[:,i] /= outdegrees[i]
      end
   end
   result
end
