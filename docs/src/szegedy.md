```@contents
Depth = 4
```
# Szegedy Quantum Walk


## Full docs

## Model definition
```@docs
AbstractSzegedy
Szegedy
sqrtstochastic
```

### General model functions
```@docs
evolve(::QWDynamics{Szegedy{<:Any,T}}, ::SparseVector{T}) where T<:Number
measure(::QWDynamics{<:AbstractSzegedy}, ::SparseVector{<:Number})
```

### Quantum search constructor
```@docs 
QWSearch(::AbstractSzegedy, ::Array{Int}, ::Real)
check_qwsearch(::AbstractSzegedy, ::Array{Int}, ::Dict{Symbol})
```

### Quantum walk constructor
```@docs 
QWEvolution(::AbstractSzegedy)
check_qwevolution(::AbstractSzegedy, ::Dict{Symbol})
```
