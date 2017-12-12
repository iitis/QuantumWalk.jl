function measure(qss::QSearch, state::Array, vertices::Array{Int})
   measure(qss.model, state, vertices)
end

#Decorating functions
function measure(qss::QSearch, state::QSearchState, vertices::Array{Int})
   measure(qss, state.state, vertices)
end

function measure(qss::QSearch, state::QSearchState, marked::Bool = true)
   if marked
      measure(qss, state.state, qss.marked)
   else
      measure(qss, state.state)
   end
end

function measure(qss::QSearch, state::Array, marked::Bool = true)
   if marked
      measure(qss.model, state, qss.marked)
   else
      measure(qss, state)
   end
end
