"""
    initial_state_szegedy
"""
function initial_state_szegedy(sqrtstochastic::SparseMatrixCSC{T}) where T<:Number
   vec(sqrtstochastic)/sqrt(size(sqrtstochastic, 1))
end

function initial_state(qss::QSearch{T}) where T<:AbstractSzegedy
   initial_state_szegedy(qss.model.sqrtstochastic)
end

## Special Szegedy evolution


"""
    evolve_szegedy_special
"""
function evolve_szegedy_special(operators::Vector{SparseMatrixCSC{T}},
                                state::SparseVector{T}) where T<:Number
   operators[2]*(operators[1]*state)
end

#general szegdy evolution (more than two operators)
"""
    evolve_szegedy_general
"""
function evolve_szegedy_general(operators::Vector{SparseMatrixCSC{T,Int}},
                                state::SparseVector{T}) where T<:Number
   for operator = operators
      state = operator*state
   end
   state
end

#decorating for szegedy
function evolve(qss::QSearch{Szegedy{G,T}},
                state::SparseVector{T}) where {G,T<:Number}
   evolve_szegedy_special(qss.parameters[:operators], state)
end

function evolve(qws::QWalkSimulator{Szegedy{G,T}},
                state::SparseVector{T}) where {G,T<:Number}
   evolve_szegedy_special(qws.parameters[:operators], state)
end

function evolve(qss::QSearch{S} where S<:AbstractSzegedy,
                state::SparseVector{T} where T<:Number)
   evolve_szegedy_general(qss.parameters[:operators], state)
end

function evolve(qws::QWalkSimulator{S} where S<:AbstractSzegedy,
                state::SparseVector{T} where T<:Number)
   evolve_szegedy_general(qws.parameters[:operators], state)
end

"""
    measure_szegedy
"""
function measure_szegedy(state::SparseVector{T} where T<:Number)
   dim = floor(Int, sqrt(length(state)))
   mapslices(sum, reshape((abs.(state)).^2, (dim, dim)), [1])
end

function measure_szegedy(state::SparseVector{T} where T<:Number,
                         vertices::Vector{Int})
   dim = floor(Int, sqrt(length(state)))
   mapslices(sum, abs.(reshape(state, (dim, dim))[:,vertices]).^2, [1])
end

function measure(qss::U where U<:AbstractSzegedy,
                 state::SparseVector{T} where T<:Number)
   measure_szegedy(state)
end

function measure(qss::U where U<:AbstractSzegedy,
                 state::SparseVector{T} where T<:Number,
                 vertices::Vector{Int})
   measure_szegedy(state, vertices)
end
