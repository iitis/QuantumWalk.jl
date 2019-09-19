
function initial_state_ctqw(::Type{T}, size::Int) where T<:Number
   fill(T(1. /sqrt(size)), size)
end

function initial_state(qws::QWSearch{<:AbstractCTQW})
   hamiltonian = qws.parameters[:hamiltonian]
   initial_state_ctqw(eltype(hamiltonian), size(hamiltonian,1))
end

function evolve(qwd::QWDynamics{<:AbstractCTQW},
                state::Vector{<:Number},
                runtime::Real)
   hamiltonian_evolution(qwd.parameters[:hamiltonian], state, runtime)
end

function measure(::QWDynamics{<:AbstractCTQW}, state::Vector{<:Number})
   abs.(state).^2
end

function measure(::QWDynamics{<:AbstractCTQW}, state::Vector{<:Number}, vertices::Vector{Int})
   abs.(state[vertices]).^2
end
