

function default_coin_operator(dim::Int)
  @assert dim > 0 "Dimension needs to be positive"
  result = spzeros(Float64, dim, dim) + 2/dim
  result - speye(result)
end
