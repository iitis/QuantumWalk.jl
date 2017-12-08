
"""
    jumping_rate



# Examples
*note* Example requires LightGraphs module.
```jldoctest

```
"""
function jumping_rate(::Type{T}, ctqw::S) where {T<:Number, S<:AbstractCTQW}
   @assert ctqw.matrix == :adjacency "Default jumping rate known for adjacency matrix only"

   if ne(ctqw.graph) == 0 # if graph is empty
      return T(1.) #does not matter
   else
      return T(1./eigs(adjacency_matrix(ctqw.graph), nev=1)[1][1])
   end
end

jumping_rate(ctqw::CTQW) = jumping_rate(Complex128, ctqw)

"""
    graph_hamlitonian

# Examples
*note* Example requires LightGraphs module.
```jldoctest

```
"""
function graph_hamlitonian(::Type{T}, ctqw::S) where {T<:Number, S<:AbstractCTQW}
   if ctqw.matrix == :adjacency
      return adjacency_matrix(ctqw.graph, T)
   elseif ctqw.matrix == :laplacian
      return laplacian_matrix(ctqw.graph, T)
   else
      throw(ErrorException("Something wrong with model: $ctqw"))
   end
end


"""
    hamiltonian_evolution(hamiltonian, time, initstate)

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
function hamiltonian_evolution(hamiltonian::DenseMatrix{T} where T<:Number,
                               initstate::Array{U} where U<:Number,
                               time::S where S<:Real)
   @assert time >= 0 "Time needs to be nonnegative"
   @assert size(hamiltonian, 1) == size(hamiltonian, 2) "hamiltonian needs to be square"
   @assert size(hamiltonian, 1) == length(initstate) "Dimensions of hamiltonian and initstate do not match"

   expm(1im*hamiltonian*time)*initstate
end


function hamiltonian_evolution(hamiltonian::SparseMatrixCSC{T} where T<:Number,
                               initstate::Array{U} where U<:Number,
                               time::S where S<:Real)
   @assert time >= 0 "Time needs to be nonnegative"
   @assert size(hamiltonian, 1) == size(hamiltonian, 2) "hamiltonian needs to be square"
   @assert size(hamiltonian, 1) == length(initstate) "Dimensions of hamiltonian and initstate do not match"

   expmv(time, 1im*hamiltonian, initstate)
end
