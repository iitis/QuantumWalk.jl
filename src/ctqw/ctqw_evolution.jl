"""
    initial_state([type, ]model)

# Examples
*note* Example requires LightGraphs module.
```jldoctest

```
"""
function initial_state(::Type{T},
                       qss::QSearch{S}) where {T<:Number, S<:AbstractCTQW}
   size = nv(graph(qss))
   fill(T(1/sqrt(size)), size)
end

function initial_state(qss::QSearch{S}) where S<:AbstractCTQW
   initial_state(eltype(qss.parameters[:hamiltonian]), qss)
end


"""
    evolve
"""
function evolve(qss::QSearch{S},
                state::Vector{T},
                runtime::U) where {S<:AbstractCTQW, T<:Number, U<:Real}
   hamiltonian_evolution(qss.parameters[:hamiltonian], state, runtime)
end

function evolve(qws::QWalkSimulator{S},
                state::Vector{T},
                runtime::U) where {S<:AbstractCTQW, T<:Number, U<:Real}
   hamiltonian_evolution(qws.parameters[:hamiltonian], state, runtime)
end

"""
    measure_state(qss, state)
    measure_state(qss, state, vertices)

# Examples
*note* Example requires LightGraphs module.
```jldoctest

```
"""


function measure(ctqw::S,
                 state::Vector{T}) where {S<:AbstractCTQW, T<:Number}
   abs.(state).^2
end

function measure(ctqw::S,
                 state::Vector{T},
                 vertices::Vector{Int}) where {S<:AbstractCTQW, T<:Number}
   abs.(state[vertices]).^2
end
