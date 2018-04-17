
function initial_state_ctqw(::Type{T}, size::Int) where T<:Number
   fill(T(1./sqrt(size)), size)
end

"""
    initial_state(qws::QWSearch{AbstractCTQW})

Returns equal superposition of size `size` and type of `qws.parameters[:hamiltonian]`.

```jldoctest
julia> qws = QWSearch(CTQW(CompleteGraph(4)), [1]);

julia> initial_state(qws)
4-element Array{Complex{Float64},1}:
 0.5+0.0im
 0.5+0.0im
 0.5+0.0im
 0.5+0.0im

```
"""
function initial_state(qws::QWSearch{<:AbstractCTQW})
   initial_state_ctqw(eltype(qws.parameters[:hamiltonian]), size(qws.parameters[:hamiltonian],1))
end

"""
    evolve(qwd, state, runtime)

Returnes new state creates by evolving `state` by `qwd.parameters[:hamiltonian]`
for time `runtime` according to Schrödinger equation.

```jldoctest
julia> qws = QWSearch(CTQW(CompleteGraph(4)), [1]);

julia> evolve(qws, initial_state(qws), 1.)
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
    measure(::QWDynamics{<:AbstractCTQW}, state)

Returns the probability of measuring each vertex from `vertices` from `state`
according to AbstractCTQW model. If `vertices` is not provided, full measurement is made.
For AbstractCTQW model measurement is done by taking square of absolute value of all elements
of state.

```jldoctest
julia> qws = QWSearch(CTQW(CompleteGraph(4)), [1]);

julia> measure(qws, sqrt.([0.2, 0.3, 0.4, 0.1]))
4-element Array{Float64,1}:
 0.2
 0.3
 0.4
 0.1

julia> measure(qws, sqrt.([0.2, 0.3, 0.4, 0.1]), [2, 3])
2-element Array{Float64,1}:
 0.3
 0.4
```
"""
function measure(::QWDynamics{<:AbstractCTQW}, state::Any)
   measure_ctqw(state)
end

function measure(::QWDynamics{<:AbstractCTQW}, state, vertices::Vector{Int})
   measure_ctqw(state, vertices)
end
