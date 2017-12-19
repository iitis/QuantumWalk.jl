
function initial_state_szegedy(sqrtstochastic::SparseMatrixCSC{T}) where T<:Real
   vec(sqrtstochastic)/sqrt(size(sqrtstochastic, 1))
end

function initial_state(qss::QSearch{T}) where T<:AbstractSzegedy
   initial_state_szegedy(qss.model.sqrtstochastic)
end

## Special Szegedy evolution
function evolve_szegedy_special(operators::Vector{SparseMatrixCSC{T,Int}},
                                state::SparseVector{T}) where T<:Real
   operators[2]*(operators[1]*state)
end

#general szegdy evolution (more than two operators)
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

function evolve(qss::QSearch{S},
                state::SparseVector{T}) where {S<:AbstractSzegedy, T<:Number}
   evolve_szegedy_general(qss.parameters[:operators], state)
end

function evolve(qws::QWalkSimulator{S},
                state::SparseVector{T}) where {S<:AbstractSzegedy, T<:Number}
   evolve_szegedy_general(qws.parameters[:operators], state)
end

function measure(szegedy::U where U<:AbstractSzegedy,
                 state::SparseVector{T} where T<:Number)
   dim = floor(Int, sqrt(length(state)))
   mapslices(sum, reshape((abs.(state)).^2, (dim, dim)), [1])
end

#probably not needed
function measure(qss::QSearch{U},
                 state::SparseVector{T} where T<:Number) where U<:AbstractSzegedy
   measure(qss.model, state)
end

function measure(qws::QWalkSimulator{U} where U<:AbstractSzegedy,
                 state::SparseVector{T} where T<:Number)
   measure(qws.model, state)
end

function measure(qss::QSearch{U} where U<:AbstractSzegedy,
                 state::SparseVector{T} where T<:Number,
                 vertices::Vector{Int})
   dim = floor(Int, sqrt(length(state)))
   mapslices(sum, reshape((abs.(state)).^2, (dim, dim))[:,vertices], [1])
end
