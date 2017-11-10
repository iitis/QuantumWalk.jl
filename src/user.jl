export
   quantumsearch


function quantumsearch(graph::Graph,
                       marked::Array{T} where T<:Int,
                       time::Real,
                       model::Symbol,
                       params::Dict{String,T} where T)

   result = Array{Float64}[]
   if model == :continuous
      result = continuous_quantum_search(graph, marked, time, params)
   else
      throw(AssertionError("Model not implemented"))
   end

end
