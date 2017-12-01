export
   continuous_quantum_search,
   continuous_maximal_probability

"""
    default_jumping_rate(graph, graphmatrixsymbol)

For given `graphmatrixsymbol` calculates jumpingrate for continuous quantum spatial
search. Currently implemented for `graphmatrixsymbol` equal to `:adjacency` only.
In this case inverse of eigenvalue with greatest magnitude is returned. If graph
is empty, 1. is returned

# Examples
*note* Example requires LightGraphs module.
```jldoctest
julia> QSpatialSearch.default_jumping_rate(CompleteGraph(10), :adjacency)
0.11111111111111109
```
"""
function default_jumping_rate(graph::Graph, graphmatrixsymbol::Symbol)
   @assert graphmatrixsymbol == :adjacency "Default graph matrix knonw for adjacency matrix only"

   if ne(graph) == 0 # if graph is empty
      return 1. #does not matter
   else
      return 1./eigs(adjacency_matrix(graph), nev=1)[1][1]
   end
end

"""
    continuous_quantum_search(graph, marked, time[, graphmatrixsymbol][, jumpingrate][, state])

Makes evolution for continuous-time quantum walk spatial search. `graph` needs
to be undirected graph and `marked` needs to be a non-empty list being a subset of vertices
of `graph`.  The evolution is made for time `time`. Parameter `graphmatrixsymbol` needs
to be equal to :adjacency or :laplacian, by default is equal to :adjacency.
For defaulty value of `graphmatrixsymbol` Parameter `jumpingrate` is calulated as the inverse
of eigenvalue of largest magnitude of adjacency matrix. If parameter `state` is `true`, the
probability distribution over vertices is returned, otherwise the resulting state
is returned. By default state is returned.

    continuous_quantum_search(graphmatrix, marked, time[, state])

The case is similar to previous, but graphmatrix is provided explicitely.


# Examples
*note* Example requires LightGraphs module.
```jldoctest
julia> continuous_quantum_search(CompleteGraph(5), [1], pi*sqrt(5)/2)
5-element Array{Complex{Float64},1}:
 0.0411606+0.953359im
 0.0986366+0.112357im
 0.0986366+0.112357im
 0.0986366+0.112357im
 0.0986366+0.112357im

julia> continuous_quantum_search(CompleteGraph(5), [1], pi*sqrt(5)/2, state=false)
5-element Array{Float64,1}:
 0.910587
 0.0223533
 0.0223533
 0.0223533
 0.0223533

julia> continuous_quantum_search(CompleteGraph(5), [1], pi*sqrt(5)/2, jumpingrate=1/5, state=false)
5-element Array{Float64,1}:
 1.0
 1.04963e-31
 1.04963e-31
 1.04963e-31
 1.04963e-31
```
"""
function continuous_quantum_search(graph::Graph,
                                   marked::Vector{Int},
                                   time::Real;
                                   graphmatrixsymbol::Symbol = :adjacency,
                                   jumpingrate::Real = default_jumping_rate(graph, graphmatrixsymbol),
                                   measure::Bool = false)
   @assert marked ⊆ collect(vertices(graph)) && marked != [] "marked needs to be non-empty subset of graph vertices set"
   @assert time >= 0 "Time needs to be nonnegative"
   @assert graphmatrixsymbol ∈ [:adjacency, :laplacian] "graphmatrixsymbol parameter needs to be :adjacency or :laplacian"

   local graphmatrix
   if graphmatrixsymbol == :adjacency
      graphmatrix = adjacency_matrix(graph)
   elseif graphmatrixsymbol == :laplacian
      graphmatrix = laplacian_matrix(graph)
   end
   graphmatrix = jumpingrate * graphmatrix

   continuous_quantum_search(graphmatrix, marked, time, measure=measure)
end

function continuous_quantum_search(graphmatrix::SparseMatrixCSC{T} where T<:Number,
                                   marked::Vector{Int},
                                   time::Real;
                                   measure::Bool = true)
   @assert time >= 0 "Time needs to be nonnegative"
   @assert size(graphmatrix, 1) == size(graphmatrix, 2) "graphmatrix needs to be square"
   graphorder = size(graphmatrix ,1)
   @assert marked ⊆ 1:graphorder && marked != [] "marked needs to be subset of 1:size(graphmatrix, 1)"

   initstate = fill((1.+0im)/sqrt(graphorder), graphorder)

   hamiltonian = graphmatrix + sum(map(x -> proj(x, graphorder), marked))
   resultstate = continuous_evolution(hamiltonian, time, initstate)

   if measure
      abs.(resultstate .* conj(resultstate))
   else
      resultstate
   end
end

function my_optimize(f::Function,
                     left::T where T<:Real,
                     right::U where U<:Real,
                     grid_step::S where S<:Real,
                     greed_number::Int,
                     abs_tol::Float64)
   data_t = left:grid_step:right
   ##optize data_t
   current_y = f.(data_t[1:greed_number])
   current_minimum = findmin(current_y)[1]+grid_step

   data_t = left:grid_step:current_minimum

   data_y = vcat([Inf], current_y, f.(data_t[(greed_number+1):end]), [Inf])
   data_t = vcat([1], data_t, [Inf])

   minimum_index = findmin(data_y)[2]
   new_left = data_t[minimum_index - 1]
   new_right = data_t[minimum_index + 1]

   return optimize(f, new_left, new_right, abs_tol=abs_tol)
end

function continuous_maximal_probability(graph::T where T<:AbstractGraph,
                                        marked::Vector{Int};
                                        graphmatrixsymbol::Symbol = :adjacency,
                                        jumpingrate::Real = default_jumping_rate(graph, graphmatrixsymbol),
                                        tmax::Real = nv(graph), #best general upper-bound, above t=0 is best
                                        which::Vector{Int} = marked)
   @assert tmax >= 0 "Time needs to be nonnegative"
   @assert marked ⊆ collect(vertices(graph)) && marked != [] "marked needs to be non-empty subset of graph vertices set"

   local graphmatrix
   if graphmatrixsymbol == :adjacency
      graphmatrix = adjacency_matrix(graph)
   elseif graphmatrixsymbol == :laplacian
      graphmatrix = laplacian_matrix(graph)
   end
   graphmatrix *= jumpingrate

   graphorder = nv(graph)
   initstate = fill((1.+0im)/sqrt(graphorder), graphorder)
   hamiltonian = graphmatrix + sum(map(x -> proj(x, graphorder), marked))

   optimized_function(t::Real) = t/sum(abs.(continuous_evolution(hamiltonian, t, initstate)[marked]).^2)

   optimal_t = Optim.minimizer(my_optimize(optimized_function, 1, graphorder, 0.2*sqrt(graphorder), 5, 0.1))::Real

   result = Dict{Symbol, Any}()
   result[:step] = optimal_t
   result[:state] = continuous_evolution(hamiltonian, optimal_t, initstate)
   result[:probability] = sum(abs.(result[:state][marked]).^2)

   result
end

"""
    continuous_evolution(hamiltonian, time, initstate)

Returns result state of quantum continuous evolution by `hamiltonian` over `time`
on initial state `initstate`. `hamiltonian` can be of type `Matrix` of `SparseMatrixCSC`.

# Examples
```
julia> QSpatialSearch.continuous_evolution([1 1; 1 3]/2, pi/sqrt(2), [1., 1.]/sqrt(2))
2-element Array{Complex{Float64},1}:
 1.66533e-16+5.55112e-17im
   -0.795693-0.6057im

```
"""
function continuous_evolution(hamiltonian::DenseMatrix{T} where T<:Number,
                              time::Real,
                              initstate::Array{T} where T<:Number)
   @assert time >= 0 "Time needs to be nonnegative"
   @assert size(hamiltonian, 1) == size(hamiltonian, 2) "hamiltonian needs to be square"
   @assert size(hamiltonian, 1) == length(initstate) "Dimensions of hamiltonian and initstate do not match"

   expm(1im*hamiltonian*time)*initstate
end


function continuous_evolution(hamiltonian::SparseMatrixCSC{T} where T<:Number,
                              time::Real,
                              initstate::Array{T} where T<:Number)
   @assert time >= 0 "Time needs to be nonnegative"
   @assert size(hamiltonian, 1) == size(hamiltonian, 2) "hamiltonian needs to be square"
   @assert size(hamiltonian, 1) == length(initstate) "Dimensions of hamiltonian and initstate do not match"

   expmv(time, 1im*hamiltonian, initstate)
end
