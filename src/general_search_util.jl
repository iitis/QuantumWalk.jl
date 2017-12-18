#measure Decorating functions
function measure(qss::QSearch, state::AbstractArray, vertices::Array{Int})
   measure(qss.model, state, vertices)
end

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

function measure(qss::QSearch, state::AbstractArray, marked::Bool = true)
   if marked
      measure(qss.model, state, qss.marked)
   else
      measure(qss, state)
   end
end

function measure(qws::QWalkSimulator, state::AbstractArray, vertices::Array{Int})
   measure(qws.model, state, vertices)
end

function measure(qws::QWalkSimulator, state::AbstractArray)
   measure(qws.model, state)
end

#Evolve decorating function
function evolve(qss::QSearch, state::QSearchState)
   evolve(qss, state.state)
end

#Expected runtime
function expected_runtime(runtime::T,
                          probability::S) where {T<:Real, S<:Real}
   if runtime == zero(T)
      Inf
   else
      runtime/probability
   end
end

function expected_runtime(state::QSearchState)
   expected_runtime(state.time, state.probability)
end
