export
   isgraphstochastic,
   szegedy_quantum_search


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

julia> QSpatialSearch.out_neighbors_looped(g, 1)
1-element Array{Int64,1}:
 3

julia> QSpatialSearch.out_neighbors_looped(g, 2)
1-element Array{Int64,1}:
 2
```
"""
function out_neighbors_looped(graph::T where T<:AbstractGraph,
                              vertex::Int)
   @assert vertex ∈ 1:nv(graph)
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
function isstochastic(stochastic::SparseDenseMatrix{Real})
   @assert size(stochastic, 1) == size(stochastic, 2) "Matrix is not square"
   @assert all(sum(stochastic[:,i]) ≈ 1 for i=1:size(stochastic, 1)) "Columns sums do not equal one"
   @assert all(findnz(stochastic)[3] .> 0 ) "Matrix elements are not nonnegative"
   return nothing
end


"""
    isstochastic(stochastic)

Checks whether `stochastic`  matrix presreves graph structure. Returns nothing.

"""
function stochastic_preserves_graph_check(graph::T where T<:AbstractGraph,
                                          stochastic::SparseDenseMatrix{Real})
   @assert size(stochastic, 1) == nv(graph) "Orders of matrix and graph do not match"
   @assert all([ i ∈ out_neighbors_looped(graph, j) for (i, j, _)=zip(findnz(stochastic)...)]) "Nonzero elements of stochastic do not coincide with graph edges"
   return nothing
end

"""
    isgraphstochastic(graph, stochastic)

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

julia> isgraphstochastic(g, stochastic)
ERROR: AssertionError: Nonzero elements of stochastic do not coincide with graph edges
Stacktrace:
 [1]
stochastic_preserves_graph_check(::LightGraphs.SimpleGraphs.SimpleDiGraph{Int64}, ::Array{Float64,2}) at /home/adam/.julia/v0.6/QSpatialSearch/src/szegedy.jl:64
 [2] isgraphstochastic(::LightGraphs.SimpleGraphs.SimpleDiGraph{Int64}, ::Array{Float64,2}) at /home/adam/.julia/v0.6/QSpatialSearch/src/szegedy.jl:87

julia> add_edge!(g, 1, 3)
true

julia> isgraphstochastic(g, stochastic)

```
"""
function isgraphstochastic(graph::T where T<:AbstractGraph,
                           stochastic::SparseDenseMatrix{Real})
   isstochastic(stochastic)
   stochastic_preserves_graph_check(graph, stochastic)
   return nothing
end

"""
    default_stochastic(digraph)

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

julia> QSpatialSearch.default_stochastic(g) |> full
5×5 Array{Float64,2}:
 0.0  0.333333  0.333333  0.0  0.0
 0.5  0.0       0.333333  1.0  0.0
 0.5  0.333333  0.0       0.0  1.0
 0.0  0.333333  0.0       0.0  0.0
 0.0  0.0       0.333333  0.0  0.0
```
"""
function default_stochastic(digraph::T where T<:AbstractGraph)
   result = adjacency_matrix(digraph, Float64, dir=:in)
   outdegrees = outdegree(digraph)
   for i = 1:size(result, 1)
      if outdegrees[i] == 0
         result[i,i] = 1
      else
         result[:,i] /= outdegrees[i]
      end
   end
   result
end






"""


"""
function szegedywalkoperators(graph::T where T<:AbstractGraph,
                              sqrtstochastic::SparseDenseMatrix{Real})
   order = size(sqrtstochastic, 1)

   r1 = 2*sum(proj(kron(ket(x, order), sqrtstochastic[:,x])) for x=1:order)
   r1 -= speye(Float64, order^2)
   r2 = 2*sum(proj(kron(sqrtstochastic[:,x], ket(x, order))) for x=1:order)
   r2 -= speye(Float64, order^2)

   (r1, r2)
end

function szegedyoracleoperators(graph::T where T<:AbstractGraph,
                                marked::Vector{T} where T<:Int)
   order = nv(graph)

   markedidentity = speye(Float64, order)
   for v=marked
      markedidentity[v,v] = -1.
   end

   q1 = kron(markedidentity, speye(order))
   q2 = kron(speye(order), markedidentity)

   (q1, q2)
end

function szegedyinitialstate(sqrtstochastic::SparseDenseMatrix{Real})
   res(sqrtstochastic)/sqrt(size(sqrtstochastic, 1))
end

function szegedymeasurement(state::Vector{T} where T<:Number)
   result = abs.(resultstate .* conj(resultstate))
   result = unres(result)
   [sum(result[:,x]) for x=1:size(result, 1)]
end

"""
    szegedy_quantum_search(graph, marked, time[, stochastic][, state])

Makes evolution for Szegedy quantum walk spatial search. `graph` needs
to be directed graph and `marked` needs to be non-empty list being a subset of vertices
of `graph`.  The evolution is made for time `time`, which needs to be positive integer.
Parameter `stochastic` needs to be squar stochastic matrix of order equal to order
of graph, by default equal to uniform random walk. Parameter `checkstochastic` checks,
whether `stochastic` is stochastic matrix preserving the graph structure. By default is
set to `false`. Note that checking may increase total run-time of the algorithm.
 If parameter `state` is `true`, the probability distribution over vertices is returned,
 otherwise the resulting state is returned. By default state is returned.

 *Note* `stochastic` needs to column stochastic (lef stochastic) matrix.

# Examples
```jldoctest


```

"""
function szegedy_quantum_search(graph::T where T<:AbstractGraph,
                                marked::Vector{T} where T<:Int,
                                time::Int64;
                                stochastic::SparseDenseMatrix{Real} = default_stochastic(graph),
                                checkstochastic::Bool = false,
                                measure::Bool = false)
   @assert time >= 0 "Time needs to be  nonnegative"
   @assert marked ⊆ collect(vertices(graph)) && marked != [] "marked needs to be non-empty subset of graph vertices set"

   if checkstochastic
      isgraphstochastic(graph, stochastic)
   end

   sqrtstochastic = sqrt.(stochastic)

   r1, r2 = szegedywalkoperators(graph, sqrtstochastic)
   q1, q2 = szegedyoracleoperators(graph, marked)

   state = szegedyinitialstate(sqrtstochastic)

   w1 = r1*q1
   w2 = r2*q2

   for t=1:time
      state = w1*state
      state = w2*state
   end

   if measure
      szegedymeasurement(state)
   else
      state
   end




end
