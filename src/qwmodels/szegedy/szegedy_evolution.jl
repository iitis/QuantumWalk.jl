
function initial_state_szegedy(sqrtstochastic::SparseMatrixCSC{<:Number})
   vec(sqrtstochastic)/sqrt(size(sqrtstochastic, 1))
end

"""
    initial_state(qws_szegedy)

Generates typical initial state for Szegedy search, see https://arxiv.org/abs/1611.02238.
Vectorizes and normalizes obtained `sqrtstochastic` matrix from `model(qws)`.
"""
function initial_state(qws::QWSearch{<:AbstractSzegedy})
   initial_state_szegedy(qws.model.sqrtstochastic)
end

"""
    evolve(qwd_szegedy, state)

Multiplies `state` be each `operator` from `operators` from quantum walk
evolution `qwd_szegedy`. Elements of operators and state should be of the same type.
"""
function evolve(qwd::QWDynamics{<:AbstractSzegedy},
                state::AbstractVector{T}) where T<:Number
   _evolve_szegedy((qwd.parameters[:operators])..., state)
end

## Special Szegedy evolution
"""
    evolve_szegedy_special(operator1, operator2, state)

Multiplies `state` be `operator1` and then by `operator2`. Elements of
operators and state should be of the same type.
"""
function _evolve_szegedy(operator1::AbstractMatrix{T},
                         operator2::AbstractMatrix{T},
                         state::AbstractVector{T}) where T<:Number
   operator2*(operator1*state)
end

"""
    measure(qwd_szegedy, state[, vertices])

Performes a measurement on `state` on `vertices`. `vertices` defaults to list of
all vertices. It is defined as the measurement of partially traced on second system state
https://arxiv.org/abs/1611.02238.
"""
function measure(::QWDynamics{<:AbstractSzegedy},
                 state::AbstractVector{<:Number})
   dim = floor(Int, sqrt(length(state)))
   vec(mapslices(sum, reshape((abs.(state)).^2, (dim, dim)), dims=[1]))
end,

function measure(::QWDynamics{<:AbstractSzegedy},
                 state::AbstractVector{<:Number},
                 vertices::Vector{Int})
   dim = floor(Int, sqrt(length(state)))
   vec(mapslices(sum, abs.(reshape(state, (dim, dim))[:,vertices]).^2, dims=[1]))
end
