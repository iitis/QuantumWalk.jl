
"""
    proj(v)

Returns a projector onto subspace spanned by `v`.
"""
function proj(v::SparseVector{T}) where T<:Number
   SparseMatrixCSC{T}(v*v')
end

function proj(v::AbstractVector{<:Number})
   v*v'
end

"""
    szegedy_walk_operators(szegedy)

Return pair of Szegedy walk operators based on `sqrtstochastic` from `szegedy`.
Definition of those can be found in https://arxiv.org/abs/1611.02238 on page 4.
The operators should be applied in given order.
"""

function szegedy_walk_operators(szegedy::AbstractSzegedy)
   order = nv(szegedy.graph)
   projectors = map(x->2. * proj(szegedy.sqrtstochastic[:,x]), 1:order)

   r1 = cat(projectors..., dims=(1, 2))

   r2 = spzeros(eltype(szegedy.sqrtstochastic), order^2, order^2)
   for x=1:order
      r2[(1:order:order^2) .+ (x-1),(1:order:order^2) .+ (x-1)] = projectors[x]
   end

   r1 -= I
   r2 -= I

   (r1, r2)
end

"""
    szegedy_oracle_operators(szegedy, marked)

Return a Szegedy oracle operators based on `sqrtstochastic` from `szegedy` and
collection of `marked` vertices. Definition of those can be found in
https://arxiv.org/abs/1611.02238 on page 6. The operators should be applied in
given order.
"""
function szegedy_oracle_operators(szegedy::AbstractSzegedy,
                                marked::Vector{Int})
   order = nv(szegedy.graph)

   markedidentity = SparseMatrixCSC{eltype(szegedy.sqrtstochastic)}(I, order, order)
   for v=marked
      markedidentity[v,v] = -1.
   end

   q1 = kron(markedidentity, SparseMatrixCSC{eltype(szegedy.sqrtstochastic)}(I, order, order))
   q2 = kron(SparseMatrixCSC{eltype(szegedy.sqrtstochastic)}(I, order, order), markedidentity)

   (q1, q2)
end
