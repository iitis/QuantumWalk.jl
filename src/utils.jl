
SparseDenseMatrix{T} = Union{SparseMatrixCSC{S}, Matrix{S}} where S<:T
SparseDenseVector{T} = Union{SparseVector{S}, Vector{S}} where S<:T

"""
    ket(index, size)

Return `index`-th base (column) vector in the `size`-dimensional vector space.
To be consistent with Julia indexing, `index` = 1, 2, ..., `size`.

# Examples

```jldoctest
julia> ket(1, 2)
2-element SparseVector{Int64, Int64} with 1 stored entry:
  [1] = 1

```
"""

function ket(T::Type, index::Int, size::Int)
   @assert size > 0 "vector size must be positive"
   @assert 1 <=  index <=  size "index must be positive and not bigger than vector size"

   result = spzeros(T, size)
   result[index] = 1
   result
end

ket(index::Int, size::Int) = ket(Float64, index, size)

"""
    bra(index, size)

Return `index`-th row vector in the `size`-dimensional vector space, with
`index` = 1, 2, ..., `size`.

# Examples

```jldoctest
julia> bra(1, 2)
1×2 RowVector{Int64, SparseVector{Int64, Int64}}:
 1  0
```
"""
bra(T::Type, index::Int, size::Int) = ket(T, index, size)'
bra(index::Int, size::Int) = ket(index, size)'

"""
    ketbra(irow, icol, size)

Return matrix acting on `size`-dimensional vector space, `irow`,
`icol` = 1, 2, ..., `size`. The matrix consists of single non-zero element
equal to one, located at position (`irow`, `icol`).

# Examples

```jldoctest
julia> ketbra(1, 2, 3)
3×3 SparseMatrixCSC{Int64, Int64} with 1 stored entry:
  [1, 2] = 1

```
"""
function ketbra(T::Type, irow::Int, icol::Int, size::Int)
  @assert size > 0 "vector size must be positive"
  @assert 1 <= irow <= size && 1 <= icol <= size "indexes must be positive and not bigger than vector size"

  result = spzeros(T, size, size)
  result[irow, icol] = 1
  result
end

ketbra(irow::Int, icol::Int, size::Int) = ketbra(Float64, irow, icol, size)

"""
    proj(index, size)

Return projector onto `index`-th base vector in `size`-dimensional vector space,
with `index` = 1, 2, ..., `size`. This is equivalent to `ketbra(index, index,
size)`.

    proj(vector)

Return projector onto the subspace spanned by vector `vector`.

# Examples
```jldoctest
julia> proj(1, 2)
2×2 SparseMatrixCSC{Int64, Int64} with 1 stored entry:
  [1, 1] = 1

julia> v = 1/sqrt(2) * (ket(1, 3)+ket(3, 3))
3-element SparseVector{Float64, Int64} with 2 stored entries:
  [1] = 0.707107
  [3] = 0.707107

julia> proj(v)
3×3 SparseMatrixCSC{Float64, Int64} with 4 stored entries:
  [1, 1] = 0.5
  [3, 1] = 0.5
  [1, 3] = 0.5
  [3, 3] = 0.5
```
"""
proj(T::Type, index::Int, size::Int) = ketbra(T, index, index, size)
proj(index::Int, size::Int) = ketbra(index, index, size)

function proj(vector::SparseDenseVector)
  vector*vector'
end

"""

    res(matrix)

Return vectorization of the `matrix` in the row order. This is equivalent to
`Base.vec(transpose(matrix)`.

# Examples

```jldoctest
julia> M = reshape(1:9, (3, 3))'*1im
3×3 Array{Complex{Int64}, 2}:
 0+1im  0+2im  0+3im
 0+4im  0+5im  0+6im
 0+7im  0+8im  0+9im

julia> v = res(M)
9-element Array{Complex{Int64}, 1}:
 0+1imjulia> unres(v)
 0+2im
 0+3im
 0+4im
 0+5im
 0+6im
 0+7im
 0+8im
 0+9im

julia> res(unres(v)) ==  v
true
```
"""
function res(matrix::SparseDenseMatrix, flip::Bool = true)
  if flip
    Base.vec(matrix.')
  else
    Base.vec(matrix)
  end
end

"""

    unres(vector)

Return square matrix with elements from `vector`. The `vector` is expected to
have perfect square number of arguments.

# Examples
```jldoctest
julia> v = collect(1:9)*im
9-element Array{Complex{Int64}, 1}:
 0+1im
 0+2im
 0+3im
 0+4im
 0+5im
 0+6im
 0+7im
 0+8im
 0+9im

julia> unres(v)
3×3 Array{Complex{Int64}, 2}:
 0+1im  0+2im  0+3im
 0+4im  0+5im  0+6im
 0+7im  0+8im  0+9im

julia> res(unres(v)) ==  v
true
```
"""
function unres(vector::SparseDenseVector, flip::Bool = true)

  dim = floor(Int64, sqrt(length(vector)))
  @assert dim*dim ==  length(vector) "Expected vector with perfect square number of elements."

  if flip
    reshape(vector, (dim, dim)).'
  else
    reshape(vector, (dim, dim))
  end
end
