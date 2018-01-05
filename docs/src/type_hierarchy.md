
# Quantum Walk models

## Full docs

### Types and its function
```@docs 
QWModel
QWModelCont
QWModelDiscr
graph(::QWModel)
```

# Quantum Dynamics 

## Full docs

### Types and its function
```@docs 
QWDynamics
model
graph(::QWDynamics)
parameters
```

### Functions
```@docs
execute(::QWDynamics, ::Any, ::Real)
execute_single(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)
execute_single_measured(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)
execute_all(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)
execute_all_measured(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)
```
