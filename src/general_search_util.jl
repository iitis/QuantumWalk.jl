#measure decorating functions
function measure(qss::QSearch, state)
   measure(qss.model, state, qss.marked)
end

function measure(qss::QSearch, state::QSearchState)
   measure(qss, state.state)
end

function measure(model::T where T<:QWalk,
                 state::QSearchState)
   measure(model, state.state)
end

function measure(model::T where T<:QWalk,
                 state::QSearchState,
                 vertices::Array{Int})
   measure(model, state.state, vertices)
end

function measure(qws::QWalkSimulator, state)
   measure(qws.model, state)
end

function measure(qws::QWalkSimulator, state::QSearchState)
   measure(qws.model, state)
end

function measure(qws::QWalkSimulator, state, vertices::Array{Int})
   measure(qws.model, state, vertices)
end

function measure(qws::QWalkSimulator, state::QSearchState, vertices::Array{Int})
   measure(qws, state.state, vertices)
end


#Evolve decorating function
function evolve(qss::QSearch, state::QSearchState)
   evolve(qss, state.state)
end

function evolve(qss::QSearch, state::QSearchState, runtime::T) where T<:Real
   evolve(qss, state.state, runtime)
end

#Expected runtime
"""
    expected_runtime
"""
function expected_runtime(runtime::T,
                          probability::S) where {T<:Real, S<:Real}
   runtime/probability
end

function expected_runtime(state::QSearchState)
   expected_runtime(state.time, state.probability)
end
