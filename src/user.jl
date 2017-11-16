export
   quantumsearch

function quantumsearch(graph::Graph,
                       marked::Array{T} where T<:Int,
                       time::Real,
                       model::Symbol;
                       measure::Bool = false)

   result = Array{Float64}[]
   if model == :continuous
      result = continuous_quantum_search(graph, marked, time, measure=measure)
   elseif model == :szegedy
      result = szegedy_quantum_search(graph, marked, time, measure=measure)
   else
      throw(AssertionError("Model not implemented"))
   end

end
