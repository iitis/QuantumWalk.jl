```@contents
Depth = 4
```
# Continuous-Time Quantum Walk

Exemplary implementation of continuous quantum walk model. The model is defined for arbitrary undirected graph. Hamiltonian is chosen to be adjacency matrix, and the evolution is made on the pure system of size equal to graph order. The definition can be found in [Spatial search by quantum walk](https://journals.aps.org/pra/abstract/10.1103/PhysRevA.70.022314), written by Childs and Goldstone.

## Full docs

### Model functions
```@docs
initial_state(::QWSearch{<:AbstractCTQW})
evolve(::QWDynamics{<:AbstractCTQW}, ::Vector{<:Number}, ::Real)
measure(::QWDynamics{<:AbstractCTQW}, ::Any)
matrix(::AbstractCTQW)
```

### Quantum search constructor
```@docs 
QWSearch(::Type{T}, ::AbstractCTQW, ::Array{Int}, ::T, ::Real = 0.) where T<:Number
check_qss
```

### Quantum walk constructor
```@docs 
QWEvolution
check_qwalksimulator
```
