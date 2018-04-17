
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
function szegedy_walk_operators(szegedy::Szegedy{<:Any,S}) where S<:Number
   order = nv(szegedy.graph)
   projectors = [2.*proj(szegedy.sqrtstochastic[:,v]) for v=1:order]

   r1 = cat([1, 2], projectors...)::SparseMatrixCSC{S,Int}

   r2 = spzeros(S, order^2, order^2)
   for x=1:order
      r2[(1:order:order^2)+x-1,(1:order:order^2)+x-1] = projectors[x]
   end

   r1 -= speye(r1)
   r2 -= speye(r2)

   (r1, r2)
end,

function szegedy_walk_operators(szegedy::AbstractSzegedy)
   order = nv(szegedy.graph)
   projectors = map(x->2.*proj(szegedy.sqrtstochastic[:,x]), 1:order)

   r1 = cat([1, 2], projectors...)

   r2 = spzeros(eltype(szegedy.sqrtstochastic), order^2, order^2)
   for x=1:order
      r2[(1:order:order^2)+x-1,(1:order:order^2)+x-1] = projectors[x]
   end

   r1 -= speye(r1)
   r2 -= speye(r2)

   (r1, r2)
end

"""
    szegedyoracleoperators(szegedy, marked)

Return a Szegedy oracle operators based on `sqrtstochastic` from `szegedy` and
collection of `marked` vertices. Definition of those can be found in
https://arxiv.org/abs/1611.02238 on page 6. The operators should be applied in
given order.
"""
function szegedyoracleoperators(szegedy::AbstractSzegedy,
                                marked::Vector{Int})
   order = nv(szegedy.graph)

   markedidentity = speye(eltype(szegedy.sqrtstochastic), order)
   for v=marked
      markedidentity[v,v] = -1.
   end

   q1 = kron(markedidentity, speye(order))
   q2 = kron(speye(order), markedidentity)

   (q1, q2)
end
