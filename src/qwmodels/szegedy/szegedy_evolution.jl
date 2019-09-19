
function initial_state_szegedy(sqrtstochastic::SparseMatrixCSC{<:Number})
   vec(sqrtstochastic)/sqrt(size(sqrtstochastic, 1))
end

function initial_state(qws::QWSearch{<:AbstractSzegedy})
   initial_state_szegedy(qws.model.sqrtstochastic)
end

function evolve(qwd::QWDynamics{<:AbstractSzegedy},
                state::AbstractVector{T}) where T<:Number
   _evolve_szegedy((qwd.parameters[:operators])..., state)
end

function _evolve_szegedy(operator1::AbstractMatrix{T},
                         operator2::AbstractMatrix{T},
                         state::AbstractVector{T}) where T<:Number
   operator2*(operator1*state)
end

function measure(::QWDynamics{<:AbstractSzegedy},
                 state::AbstractVector{<:Number})
   dim = floor(Int, sqrt(length(state)))
   vec(mapslices(sum, reshape((abs.(state)).^2, (dim, dim)), dims=[1]))
end

function measure(::QWDynamics{<:AbstractSzegedy},
                 state::AbstractVector{<:Number},
                 vertices::Vector{Int})
   dim = floor(Int, sqrt(length(state)))
   vec(mapslices(sum, abs.(reshape(state, (dim, dim))[:,vertices]).^2, dims=[1]))
end
