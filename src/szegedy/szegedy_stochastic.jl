"""
    out_neighbors_looped(graph, vertex)

Return lists of outneighbors of `vertex` in `graph`. If outdegree of `vertex` is
zero, then [v] is returned.

# Example
*Note* Example requires LightGraphs package.

```jldoctest
julia> g = DiGraph(3)
{3, 0} directed simple Int64 graph

julia> add_edge!(g, 1, 3)
true

julia> QuantumWalk.out_neighbors_looped(g, 1)
1-element Array{Int64,1}:
 3

julia> QuantumWalk.out_neighbors_looped(g, 2)
1-element Array{Int64,1}:
 2
```
"""
function out_neighbors_looped(graph::AbstractGraph, vertex::Int)
   outneighbors = out_neighbors(graph, vertex)
   if outneighbors == []
      return [vertex]
   end
   outneighbors
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

Checks whether `stochastic`  matrix presreves graph structure. Returns nothing.
Accepts both Graph and DiGraph.

"""
function graphpreservationcheck(graph::AbstractGraph,
                                stochastic::SparseMatrixCSC{<:Number})
   @assert size(stochastic, 1) == nv(graph) "Orders of matrix and graph do not match"
   @assert all([ i ∈ out_neighbors_looped(graph, j) for (i, j, _)=zip(findnz(stochastic)...)]) "Nonzero elements of stochastic do not coincide with graph edges"
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

# Examples
*Note* Example requires LightGraphs package.

```jldoctest
julia> g = DiGraph(3)
{3, 0} directed simple Int64 graph

julia> add_edge!(g, 1, 2)
true

julia> stochastic = [0. 0. 0.; 1./3 1. 0.; 2./3 0. 1.]
3×3 Array{Float64,2}:
0.0       0.0  0.0
 0.333333  1.0  0.0
 0.666667  0.0  1.0

julia> graphstochasticcheck(g, stochastic)
ERROR: AssertionError: Nonzero elements of stochastic do not coincide with graph edges
Stacktrace:
 [1]
stochastic_preserves_graph_check(::LightGraphs.SimpleGraphs.SimpleDiGraph{Int64}, ::Array{Float64,2}) at /home/adam/.julia/v0.6/QuantumWalk/src/szegedy.jl:64
 [2] graphstochasticcheck(::LightGraphs.SimpleGraphs.SimpleDiGraph{Int64}, ::Array{Float64,2}) at /home/adam/.julia/v0.6/QuantumWalk/src/szegedy.jl:87

julia> add_edge!(g, 1, 3)
true

julia> graphstochasticcheck(g, stochastic)

```
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
uniform spreading. Function accepts both `DiGraph` and `Graph` types. If outdegree
of vertex is zero, additional 1 is added on the diagonal.

# Examples
*Note* Example requires LightGraphs package.

```jldoctest
julia> g = smallgraph(:bull)
{5, 5} undirected simple Int64 graph

julia> adjacency_matrix(g, dir=:in) |> full
5×5 Array{Int64,2}:
 0  1  1  0  0
 1  0  1  1  0
 1  1  0  0  1
 0  1  0  0  0
 0  0  1  0  0

julia> QuantumWalk.default_stochastic(g) |> full
5×5 Array{Float64,2}:
 0.0  0.333333  0.333333  0.0  0.0
 0.5  0.0       0.333333  1.0  0.0
 0.5  0.333333  0.0       0.0  1.0
 0.0  0.333333  0.0       0.0  0.0
 0.0  0.0       0.333333  0.0  0.0
```
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
