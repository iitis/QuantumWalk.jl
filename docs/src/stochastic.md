```@meta
DocTestSetup = quote
   using QuantumWalk, LightGraphs
end
```

## Stochastic Random Walk

## Documentation

```@index
Order = [:type, :function]
Modules = [QuantumWalk]
Pages   = ["stochastic.md"]
```

### Full docs

```@docs
AbstractStochastic
Stochastic
UniformStochastic
QWEvolution(::AbstractStochastic)
QWSearch(::AbstractStochastic, ::Vector{Int}, ::Real)
check_qwdynamics(::Type{QWSearch}, ::AbstractStochastic, ::Dict{Symbol}, ::Vector{Int})
check_qwdynamics(::Type{QWEvolution}, ::AbstractStochastic, ::Dict{Symbol})
stochastic_matrix(::Stochastic)
stochastic_matrix(::UniformStochastic)
```
