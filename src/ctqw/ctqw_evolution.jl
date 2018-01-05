
function initial_state_ctqw(::Type{T}, size::Int) where T<:Number
   fill(T(1/sqrt(size)), size)
end

"""
    initial_state(qss::QWSearch{AbstractCTQW})

Returns equal superposition of size `size` and type of `qss.parameters[:hamiltonian]`.

```@docs
julia> qss = QWSearch(CTQW(CompleteGraph(4)), [1]);

julia> initial_state(qss)
4-element Array{Complex{Float64},1}:
 0.5+0.0im
 0.5+0.0im
 0.5+0.0im
 0.5+0.0im

```
"""
function initial_state(qss::QWSearch{<:AbstractCTQW})
   initial_state_ctqw(eltype(qss.parameters[:hamiltonian]), size(qss.parameters[:hamiltonian],1))
end

"""
    evolve(qwd, state, runtime)

Returnes new state creates by evolving `state` by `qwd.parameters[:hamiltonian]`
for time `runtime` according to Schrödinger equation.

```@docs
julia> qwd = QWSearch(CTQW(CompleteGraph(4)), [1]);

julia> evolve(qwd, initial_state(qss), 1.)
4-element Array{Complex{Float64},1}:
 -0.128942+0.67431im
  0.219272+0.357976im
  0.219272+0.357976im
  0.219272+0.357976im

```
"""
function evolve(qwd::QWDynamics{<:AbstractCTQW},
                state::Vector{<:Number},
                runtime::Real)
   hamiltonian_evolution(qwd.parameters[:hamiltonian], state, runtime)
end

function measure_ctqw(state::Vector{<:Number})
   abs.(state).^2
end

function measure_ctqw(state::Vector{<:Number},
                      vertices::Vector{Int})
   abs.(state[vertices]).^2
end

"""
    measure(qwd::QWDynamics{<:AbstractCTQW}, state [, vertices])

Returns the probability of measuring each vertex from `vertices` from `state`
according to AbstractCTQW model. If `vertices` is not provided, full measurement is made.
For AbstractCTQW model measurement is done by taking square of absolute value of all elements
of state.

```@docs
julia> qss = QWSearch(CTQW(CompleteGraph(4)), [1]);

julia> measure(qss, [sqrt(0.2), sqrt(0.3), sqrt(0.5)])
3-element Array{Float64,1}:
 0.2
 0.3
 0.5

 julia> measure(qss, [sqrt(0.2), sqrt(0.3), sqrt(0.5)], [2, 3])
 2-element Array{Float64,1}:
  0.3
  0.5

```
"""
function measure(::QWDynamics{<:AbstractCTQW}, state)
   measure_ctqw(state)
end

function measure(::QWDynamics{<:AbstractCTQW}, state, vertices::Vector{Int})
   measure_ctqw(state, vertices)
end
