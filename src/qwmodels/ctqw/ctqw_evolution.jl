
function initial_state_ctqw(::Type{T}, size::Int) where T<:Number
   fill(T(1. /sqrt(size)), size)
end

"""
    initial_state(qws_ctqw)

Returns equal superposition of size `size` and type of `parameters(qws_ctqw)[:hamiltonian]`.
"""
function initial_state(qws::QWSearch{<:AbstractCTQW})
   hamiltonian = qws.parameters[:hamiltonian]
   initial_state_ctqw(eltype(hamiltonian), size(hamiltonian,1))
end

"""
    evolve(qwd_ctqw, state, runtime)

Returnes new state creates by evolving `state` by `parameters(qwd_ctqw)[:hamiltonian]`
for time `runtime` according to Schrödinger equation.
"""
function evolve(qwd::QWDynamics{<:AbstractCTQW},
                state::Vector{<:Number},
                runtime::Real)
   hamiltonian_evolution(qwd.parameters[:hamiltonian], state, runtime)
end

"""
    measure(qwd_ctqw, state[, vertices])

Returns the probability of measuring each vertex from `vertices` from `state`
according to `qwd_ctqw` model. If `vertices` is not provided, full measurement is made.
The measurement is done by taking square of absolute value of all elements
of state.
"""
function measure(::QWDynamics{<:AbstractCTQW}, state::Vector{<:Number})
   abs.(state).^2
end,

function measure(::QWDynamics{<:AbstractCTQW}, state::Vector{<:Number}, vertices::Vector{Int})
   abs.(state[vertices]).^2
end
