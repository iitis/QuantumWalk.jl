"""
    initial_state_ctqw
"""
function initial_state_ctqw(::Type{T}, size::Int) where T<:Number
   fill(T(1/sqrt(size)), size)
end

function initial_state(qss::QSearch{S} where S<:AbstractCTQW)
   initial_state_ctqw(eltype(qss.parameters[:hamiltonian]), size(qss.parameters[:hamiltonian]))
end

"""
    evolve_ctqw
"""
function evolve_ctqw(hamiltonian::AbstractMatrix{S} where S<:Number,
                     state::Vector{T} where T<:Number,
                     runtime::U where U<:Real)
   hamiltonian_evolution(hamiltonian, state, runtime)
end

function evolve(qss::QSearch{S} where S<:AbstractCTQW,
                state::Vector{T} where T<:Number,
                runtime::U where U<:Real)
   evolve_ctqw(qss.parameters[:hamiltonian], state, runtime)
end

function evolve(qws::QWalkSimulator{S} where S<:AbstractCTQW,
                state::Vector{T} where T<:Number,
                runtime::U where U<:Real)
   evolve_ctqw(qws.parameters[:hamiltonian], state, runtime)
end

"""
    measure_ctqw
"""
function measure_ctqw(state::Vector{T} where T<:Number)
   abs.(state).^2
end

function measure_ctqw(state::Vector{T} where T<:Number,
                      vertices::Vector{Int})
   abs.(state[vertices]).^2
end

function measure(ctqw::S where S<:AbstractCTQW,
                 state::Vector{T} where T<:Number)
   measure_ctqw(state)
end

function measure(ctqw::S where S<:AbstractCTQW,
                 state::Vector{T} where T<:Number,
                 vertices::Vector{Int})
   measure_ctqw(state, vertices)
end
