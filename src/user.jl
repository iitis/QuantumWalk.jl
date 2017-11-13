export
   quantumsearch


function quantumsearch(graph::Graph,
                       marked::Array{T} where T<:Int,
                       time::Real,
                       model::Symbol;
                       state::Bool = true)

   result = Array{Float64}[]
   if model == :continuous
      result = continuous_quantum_search(graph, marked, time, state=state)
   elseif model == :szegedy
      result = szegedy_quantum_search(graph, marked, time)
   else
      throw(AssertionError("Model not implemented"))
   end

end
