
function initial_state_szegedy(sqrtstochastic::SparseMatrixCSC{<:Number})
   vec(sqrtstochastic)/sqrt(size(sqrtstochastic, 1))
end

"""
    initial_state(qss::QWSearch{<:AbstractSzegedy})

Generates typical initial state for Szegedy search, see https://arxiv.org/abs/1611.02238.
Vectorizes and normalizes obtained `sqrtstochastic` matrix from `model(qss)`.
Note that the state
may not be uniform supersposition in general, but it gives uniform superposition
after partial tracing second system.

```@docs
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> initial_state(qss)
16-element SparseVector{Float64,Int64} with 12 stored entries:
  [2 ]  =  0.288675
  [3 ]  =  0.288675
  [4 ]  =  0.288675
  [5 ]  =  0.288675
  [7 ]  =  0.288675
  [8 ]  =  0.288675
  [9 ]  =  0.288675
  [10]  =  0.288675
  [12]  =  0.288675
  [13]  =  0.288675
  [14]  =  0.288675
  [15]  =  0.288675

```
"""
function initial_state(qss::QWSearch{<:AbstractSzegedy})
   initial_state_szegedy(qss.model.sqrtstochastic)
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

#decorating for szegedy
"""
    evolve(qwe::QWSearch{AbstractSzegedy}, state)

Multiplies `state` be each `operator` from `operators` from quatnum walk
evolution `qwe`. Elements of operators and state should be of the same type.

```@docs
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> evolve(qss, initial_state(qss))
16-element SparseVector{Float64,Int64} with 12 stored entries:
  [2 ]  =  0.481125
  [3 ]  =  0.481125
  [4 ]  =  0.481125
  [5 ]  =  -0.288675
  [7 ]  =  -0.096225
  [8 ]  =  -0.096225
  [9 ]  =  -0.288675
  [10]  =  -0.096225
  [12]  =  -0.096225
  [13]  =  -0.288675
  [14]  =  -0.096225
  [15]  =  -0.096225

```
"""
function evolve(qwd::QWDynamics{Szegedy{<:Any,T}},
                state::SparseVector{T}) where T<:Number
   evolve_szegedy_special((qwd.parameters[:operators])..., state)
end

function evolve(qwd::QWDynamics{<:AbstractSzegedy},
                state::SparseVector{<:Number})
   evolve_szegedy_general(qwd.parameters[:operators], state)
end


function measure_szegedy(state::SparseVector{<:Number})
   dim = floor(Int, sqrt(length(state)))
   vec(mapslices(sum, reshape((abs.(state)).^2, (dim, dim)), [1]))
end

function measure_szegedy(state::SparseVector{<:Number},
                         vertices::Vector{Int})
   dim = floor(Int, sqrt(length(state)))
   vec(mapslices(sum, abs.(reshape(state, (dim, dim))[:,vertices]).^2, [1]))
end

"""
    measure(qwd::AbstractSzegedy, state[, vertices])

Performes a measurement on `state` on `vertices`. `vertices` defaults to list of
all vertices. It is defined as the measurement of partially traced on second system state
https://arxiv.org/abs/1611.02238.

```@docs
julia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);

julia> state = evolve(qss, initial_state(qss));

julia> measure(qss, state)
4-element Array{Float64,1}:
 0.694444
 0.101852
 0.101852
 0.101852

julia> measure(qss, state, [1,3])
2-element Array{Float64,1}:
 0.694444
 0.101852

```
"""
function measure(::QWDynamics{<:AbstractSzegedy},
                 state::SparseVector{<:Number})
   measure_szegedy(state)
end

function measure(::QWDynamics{<:AbstractSzegedy},
                 state::SparseVector{<:Number},
                 vertices::Vector{Int})
   measure_szegedy(state, vertices)
end
