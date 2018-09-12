```@meta
DocTestSetup = quote
   using QuantumWalk, LightGraphs
end
```

## Szegedy Quantum Walk

The Szegedy quantum walk is one of the most popular discrete quantum walk models. It takes stochastic matrix, turns it into unitary operator and use it for evolution. The evolution is purely unitary on the dimension equal to square of the graph order. The definition can be found in [Quantum speed-up of Markov chain based algorithms](http://ieeexplore.ieee.org/abstract/document/1366222/) by Szegedy. The definition of quantum search can be found in [Direct Equivalence of Coined and Szegedy's Quantum Walks](https://arxiv.org/abs/1611.02238) by Wong.

The abstract supertype is `AbstractSzegedy` with its default realization `Szegedy`.
The model includes following types and methods:

## Documentation

```@index
Order = [:type, :function]
Modules = [QuantumWalk]
Pages   = ["szegedy.md"]
```

### Full docs

```@docs
AbstractSzegedy
QWEvolution(::AbstractSzegedy)
QWSearch(::AbstractSzegedy, ::Vector{Int}, ::Real)
Szegedy
check_qwdynamics(::Type{QWSearch}, ::AbstractSzegedy, ::Dict{Symbol}, ::Vector{Int})
check_qwdynamics(::Type{QWEvolution}, ::AbstractSzegedy, ::Dict{Symbol})
evolve(::QWDynamics{Szegedy{<:Any,T}}, ::SparseVector{T}) where T<:Number
initial_state(::QWSearch{<:AbstractSzegedy})
measure(::QWDynamics{<:AbstractSzegedy}, ::SparseVector{<:Number})
sqrtstochastic(::AbstractSzegedy)
```
