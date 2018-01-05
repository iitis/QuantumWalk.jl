```@contents
Depth = 4
```
# Quantum Search

## Full docs

### Types and its function
```@docs 
QWSearch
marked
penalty
```

```@docs
check_qwsearch
```

```@docs
execute(::QWSearch, ::Real)
execute_single(::QWSearch{<:QWModelDiscr}, ::Any, ::Int)
execute_single_measured(::QWSearch{<:QWModelDiscr}, ::Int)
execute_all(::QWSearch{<:QWModelDiscr}, ::S, ::Int) where S
execute_all_measured(::QWSearch{<:QWModelDiscr}, ::Int)
```

```@docs
maximize_quantum_search
```

### QSearchState

```@docs
QSearchState
state
probability
runtime
```

```@docs
expected_runtime
```

