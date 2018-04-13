```@meta
DocTestSetup = quote
   using QuantumWalk, LightGraphs
end
```

# Quantum Search

Quantum spatial search is an algorithm, which starts at some initial state (which
 depends on the graph structure), and runs for some time in order to cumulate
 amplitude at marked vertex. The algorithm is known to outperform classical search.

 The dynamics requires `evolve`, `measure`, `initial_state` and `check_qwdynamics` functions. It provides `execute`, `execute_single`, `execute_single_measured`, `execute_all` and `execute_all_measured` functions - the description can be found in *Quantum walk evolution* section. The only difference is that `QWSearch` uses the state provided by `initial_state` function, unless other is provided. Furthermore the function provides `marked`, `penalty` and `maximize_quantum_search`. While the first two simple provides the parameters typical to `QWSearch`, the last one searches for optimal measure time. The maximization depends on the model (if it is continuous or discrete). While for discrete evolution obtaining reasonable result is guaranteed, it is not the case for the continuous one, as the optimization suffers for locating at local extrema.

 The `penalty` is an additional time added in optimization. Note, that if we optimize
 time/success_probability(time) function, the optimum is always at time 0. This would imply that algorithm achieves full efficiency if it is instantly measured. This is misleading, as the time for constructing initial state and for measurement is ignored.
 Hence we need to include (usually small) additional time in `penalty` in order to
 get useful result. Note the  time/success_probability(time) is at called
 *expected_runtime* and can be obtained by `expected_runtime` function.

 Some function as a result outputs not `QSearchState` instead of the original state.
 The struct consists of the original state, the runtime and the probability of measuring
 each marked vertex. Those elements can be extracted by `state`, `runtime` and `probability` functions.

 Following functions are connected to the quantum search:
```@index
Order = [:type, :function]
Modules = [QuantumWalk]
Pages   = ["quantum_search.md"]
```
## Example

```
using QuantumWalk, LightGraphs

n = 100
penalty_szegedy = log(n)
qsearch = QWSearch(Szegedy(CompleteGraph(n)), [1], penalty_szegedy)

runtime(maximize_quantum_search(qsearch))-penalty_szegedy
# 5.0

probability(maximize_quantum_search(qsearch))
# [0.569689]

execute_single_measured(qsearch, ceil(Int, pi*sqrt(100)/2))
#100-element Array{Float64,1}:
# 0.428475  
# 0.00577298
# 0.00577298
# 0.00577298
# 0.00577298
# 0.00577298
  ⋮         
# 0.00577298
# 0.00577298
# 0.00577298
# 0.00577298
# 0.00577298
```

## Adjusting model to `QWSearch`

Here we consider the example from the *Quantum walk evolution* section. We can consider
random walk search as follows: at given step we check if we are at the marked vertex.
If not, we continue evolution. Hence we need to cumulate the success probability
at marked vertices. We can propose following implementation (including the functions
from mentioned section).

```julia
##
function check_qwdynamics(::Type{QWSearch},
                          abs_stoch::UniformStochastic,
                          ::Array{Int},
                          parameters::Dict{Symbol,Any})
  @assert :stochastic ∈ keys(parameters) "parameters needs to have key stochastic"
  n = nv(graph(abs_stoch))
  @assert isa(parameters[:stochastic], SparseMatrixCSC{<:Real}) "value for :stochastic needs to be sparse matrix with real numbers"
  @assert size(parameters[:stochastic], 1) == size(parameters[:stochastic], 2) "Stochastic matrix needs to be square stochastic matrix"
  @assert mapslices(sum, parameters[:stochastic], 1)[1,:] ≈ ones(n) "Stochastic matrix needs to be square stochastic matrix of order graph"
end

function QWSearch(stoch::AbstractStochastic,
                  marked::Array{Int},
                  penalty::Real = 0.)
   parameters = Dict{Symbol,Any}(:stochastic => stochastic_matrix(graph(stoch)))

   QWSearch(stoch, marked, parameters, penalty)
end

function initial_state(qss::QWSearch{<:AbstractStochastic})
  n = nv(graph(qss))
  fill(1./n, n)
end

function evolve(qss::QWSearch{<:AbstractStochastic}, state::Vector{<:Real})
  old_probability = measure(qss, state, marked(qss))
  state[marked(qss)] = zero(marked(qss))
  state = stochastic_evolution(parameters(qss)[:stochastic], state)
  state[marked(qss)] += old_probability
  state
end
```
Note that for example `measure` function does not change. Below we provide an
evolution simulation example.

```julia
dynamic = QWSearch(UniformStochastic(CompleteGraph(100)), [1])

measure(dynamic, execute_single(dynamic, 0), [1])
# [0.01]

measure(dynamic, execute_single(dynamic, 40), [1])
# [0.340416]

measure(dynamic, execute_single(dynamic, 1000), [1])
# [0.999961]
```

## Full docs

```@docs
QWSearch
marked(qss::QWSearch)
penalty(qss::QWSearch)
check_qwdynamics(::QWSearch, ::Vector{Int}, ::Dict{Symbol})
execute(::QWSearch, ::Real)
execute_single(qss::QWSearch{<:QWModelDiscr}, initstate, runtime::Int)
execute_single(qss::QWSearch{<:QWModelCont}, initstate, runtime::Real)
execute_single(qss::QWSearch, runtime::Real)
execute_single_measured(::QWSearch{<:QWModelDiscr}, ::Int)
execute_all(::QWSearch{<:QWModelDiscr}, ::Any, ::Int)
execute_all_measured(::QWSearch{<:QWModelDiscr}, ::Int)
initial_state
maximize_quantum_search
QSearchState
state
probability
runtime
expected_runtime
```
