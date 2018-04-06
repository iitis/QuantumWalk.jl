# Quantum Search

Quantum spatial search is an algorithm, which starts at some initial state (which
 depends on the graph structure), and runs for some time in order to cumulate
 amplitude at marked vertex. The algorithm is know to outperform classical search.

 The dynamics requires `evolve`, `measure`, `initial_state` and `check_qwdynamics` functions. It provides `execute`, `execute_single`, `execute_single_measured`, `execute_all` and `execute_all_measured` functions - the description can be found in *Quantum walk evolution* section. The only difference is that `QWSearch` uses the state provided by `initial_state` function, unless other is provided. Furthermore the function provides `marked`, `penalty` and `maximize_quantum_search`. While the first two simple provides the parameters typical to `QWSearch`, the last one searches for optimal measure time. The maximization depends on the model (if it is continuous or discrete). While for discrete evolution obtaining reasonable result is guaranteed, it is not the case for the continuous one, as the optimization suffers locating at local extremum.

 The `penalty` is an additional time added in optimization. Note, that if we optimize
 time/success_probability(time) function, the optimum is always at time 0. This would imply that algorithm achieves full efficiency if it is instantly measured. This is misleading, as the time for constructing initial state and for measurement is ignored.
 Hence we need to include (usually small) additional time in `penalty` in order to
 get useful result. Note the  time/success_probability(time) is at called
 *expected_runtime* and can be obtained by `expected_runtime` function.

 Some function as a result outputs not `QSearchState` instead of the original state.
 The struct consists of the original state, the runtime and the probability of measuring
 each marked vertex. Those elements can be extracted by `state`, `runtime` and `probability` functions.

 Following functions are connected to the dynamics:
```@index
Order = [:type, :function]
Modules = [QuantumWalk]
Pages   = ["quantum_walk.md"]
```
## Example

TODO

## Adjusting model to `QWSearch`

TODO

## Full docs

```@docs
QWSearch
marked
penalty
check_qwdynamics
execute(::QWSearch, ::Real)
execute_single(::QWSearch{<:QWModelDiscr}, ::Any, ::Int)
execute_single_measured(::QWSearch{<:QWModelDiscr}, ::Int)
execute_all(::QWSearch{<:QWModelDiscr}, ::S, ::Int) where S
execute_all_measured(::QWSearch{<:QWModelDiscr}, ::Int)
maximize_quantum_search
QSearchState
state
probability
runtime
expected_runtime
```
