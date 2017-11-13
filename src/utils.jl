
SparseDenseMatrix = Union{SparseMatrixCSC{T} where T<:Number, Matrix{S} where S<:Number}

"""
    proj(index, size)

Return projector onto `index`-th base vector in `size`-dimensional vector space,
with `index` = 1, 2, ..., `size`.

# Examples
```jldoctest
julia> proj(1, 2)
2×2 SparseMatrixCSC{Int64, Int64} with 1 stored entry:
  [1, 1] = 1
```
"""
function proj(index::Int, size::Int)
   @assert size>0 "Size needs to be positive"
   @assert 1 <= index <= size "Index needs to be positive and at most size"
   result = spzeros(Int, size, size)
   result[index, index] = 1
   result
end
