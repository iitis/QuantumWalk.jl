export
   expected_runtime

#measure decorating functions
function measure(qwe::QWSearch, state::QSearchState)
   measure(qwe, state.state)
end

function measure(qwe::QWSearch, state::QSearchState, vertices::Vector{Int})
   measure(qwe, state.state, vertices)
end

#Evolve decorating function
function evolve(qwe::QWSearch, state::QSearchState)
   evolve(qwe, state.state)
end

function evolve(qwe::QWSearch, state::QSearchState, runtime::T) where T<:Real
   evolve(qwe, state.state, runtime)
end

#Expected runtime
"""
    expected_runtime(runtime, probability)
    expected_runtime(state)

Returns the expected runtime needed for quantum walk, considering it as Bernoulli
process. It equals to `runtime/probability`. In the case of `state` provided the
measurement is made, penalty is included.
"""
function expected_runtime(runtime::Real, probability::Real)
   runtime/probability
end,

function expected_runtime(qws::QWSearch, state::QSearchState)
   expected_runtime(state.runtime + state.penalty, sum(state.probability))
end
