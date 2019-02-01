
function initial_state(qws::QWSearch{<:AbstractStochastic})
  n = nv(graph(qws))
  fill(1. / n, n)
end

function stochastic_evolution(s::AbstractMatrix{T}, v::Vector{T}) where T<:Real
  s*v
end

function evolve(qws::QWDynamics{<:AbstractStochastic}, state)
  stochastic_evolution(parameters(qws)[:stochastic], state)
end

function measure(::QWDynamics{<:AbstractStochastic}, state::Vector{<:Real})
   return state
end

function measure(::QWDynamics{<:AbstractStochastic},
                 state::Vector{<:Real},
                 vertices::Vector{Int})
   return state[vertices]
end
