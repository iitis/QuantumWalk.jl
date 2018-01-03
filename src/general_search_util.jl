"""
    QSearchState
"""
struct QSearchState{S,Y<:Real}
  state::S
  probability::Array{Float64}
  time::Y

  function QSearchState(state::S,
                        probability::Array{Float64},
                        runtime::Y) where {S,Y<:Real}
     new{S,Y}(state, probability, runtime)
  end
end

function QSearchState(qss::QSearch, state, runtime::Real)
   QSearchState(state, measure(qss, state, qss.marked), runtime)
end


#measure decorating functions
function measure(qwe::QWalkEvolution, state::QSearchState)
   measure(qwe, state.state, qss.marked)
end

function measure(qwe::QWalkEvolution, state::QSearchState, vertices::Array{Int})
   measure(qwe, state.state, vertices)
end

#Evolve decorating function
function evolve(qwe::QWalkEvolution, state::QSearchState)
   evolve(qwe, state.state)
end

function evolve(qwe::QWalkEvolution, state::QSearchState, runtime::T) where T<:Real
   evolve(qwe, state.state, runtime)
end

#Expected runtime
"""
    expected_runtime
"""
function expected_runtime(runtime::Real,
                          probability::Real)
   runtime/probability
end

function expected_runtime(state::QSearchState)
   expected_runtime(state.time, sum(state.probability))
end
