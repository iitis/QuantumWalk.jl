
function initial_state_szegedy(sqrtstochastic::SparseMatrixCSC{<:Number})
   vec(sqrtstochastic)/sqrt(size(sqrtstochastic, 1))
end

"""
    initial_state(qws::QWSearch{<:AbstractSzegedy})

Generates typical initial state for Szegedy search, see https://arxiv.org/abs/1611.02238.
Vectorizes and normalizes obtained `sqrtstochastic` matrix from `model(qws)`.
"""
function initial_state(qws::QWSearch{<:AbstractSzegedy})
   initial_state_szegedy(qws.model.sqrtstochastic)
end

#decorating for szegedy
"""
    evolve(qwd::QWDynamics{AbstractSzegedy}, state::SparseVector)

Multiplies `state` be each `operator` from `operators` from quantum walk
evolution `qwd`. Elements of operators and state should be of the same type.
"""
function evolve(qwd::QWDynamics{Szegedy{<:Any,T}},
                state::SparseVector{T}) where T<:Number
   evolve_szegedy_special((qwd.parameters[:operators])..., state)
end

function evolve(qwd::QWDynamics{<:AbstractSzegedy},
                state::SparseVector{<:Number})
   evolve_szegedy_general(qwd.parameters[:operators], state)
end

## Special Szegedy evolution
"""
    evolve_szegedy_special(operator1, operator2, state)

Multiplies `state` be `operator1` and then by `operator2`. Elements of
operators and state should be of the same type.
"""
function evolve_szegedy_special(operator1::SparseMatrixCSC{T, Int},
                                operator2::SparseMatrixCSC{T, Int},
                                state::SparseVector{T}) where T<:Number
   operator2*(operator1*state)
end

#general szegdy evolution (more than two operators)
"""
    evolve_szegedy_general(operators, state)

Multiplies `state` be each `operator` from `operators` in given order.
Elements of operators and state should be of the same type.
"""
function evolve_szegedy_general(operators::Vector{SparseMatrixCSC{T, Int}},
                                state::SparseVector{T}) where T<:Number
   for operator = operators
      state = operator*state
   end
   state
end

"""
    measure(qwd::AbstractSzegedy, state::SparseVector{<:Number}[, vertices])

Performes a measurement on `state` on `vertices`. `vertices` defaults to list of
all vertices. It is defined as the measurement of partially traced on second system state
https://arxiv.org/abs/1611.02238.
"""
function measure(::QWDynamics{<:AbstractSzegedy},
                 state::SparseVector{<:Number})
   dim = floor(Int, sqrt(length(state)))
   vec(mapslices(sum, reshape((abs.(state)).^2, (dim, dim)), [1]))
end,

function measure(::QWDynamics{<:AbstractSzegedy},
                 state::SparseVector{<:Number},
                 vertices::Vector{Int})
   dim = floor(Int, sqrt(length(state)))
   vec(mapslices(sum, abs.(reshape(state, (dim, dim))[:,vertices]).^2, [1]))
end
