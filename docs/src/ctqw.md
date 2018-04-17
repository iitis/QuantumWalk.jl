```@meta
DocTestSetup = quote
   using QuantumWalk, LightGraphs
end
```

# Continuous-Time Quantum Walk

Implementation of continuous-time quantum walk. The model is defined for arbitrary undirected graph. Hamiltonian is chosen to be adjacency or Laplacian matrix. After the evolution, state is measured in canonic basis. The evolution is made on the pure system of size equal to graph order. The precise definition can be found in [Spatial search by quantum walk](https://journals.aps.org/pra/abstract/10.1103/PhysRevA.70.022314) by Childs and Goldstone, where both pure walk and search dynamics are described.

The abstract supertype is `AbstractCTQW` with its default realization `CTQW`. The model includes following types and methods:

```@index
Order = [:type, :function]
Modules = [QuantumWalk]
Pages   = ["ctqw.md"]
```

## Full docs

```@docs
AbstractCTQW
CTQW
QWEvolution(::Type{U}, ::AbstractCTQW) where U<:Number
QWSearch(::Type{T}, ::AbstractCTQW, ::Array{Int}, ::T, ::Real = 0.) where T<:Number
check_qwdynamics(::Type{QWSearch}, ::AbstractCTQW, ::Array{Int}, ::Dict{Symbol})
check_qwdynamics(::Type{QWEvolution}, ::AbstractCTQW, ::Dict{Symbol})
evolve(::QWDynamics{<:AbstractCTQW}, ::Vector{<:Number}, ::Real)
initial_state(::QWSearch{<:AbstractCTQW})
matrix(::AbstractCTQW)
measure(::QWDynamics{AbstractCTQW}, ::Any) 
```
