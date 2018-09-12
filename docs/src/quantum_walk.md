```@meta
DocTestSetup = quote
   using QuantumWalk, LightGraphs
end
```

## Quantum walk evolution

The simplest quantum walk evolution. It simply takes the model and initial state from
the user, simulate an evolution and outputs the state or the probability distribution
of measured state.

The dynamics requires `evolve`, `measure` and `check_qwdynamics` functions.
It provides `execute`, `execute_single`, `execute_single_measured`, `execute_all` and
`execute_all_measured` functions. Depending on the name it outputs single state
or all states, measured or not measured. The execute combines the last four functions.
In the case of type-stability requirement, we recommend to use the last four
functions.

**Note:** Methods `execute_all` and `execute_all_measured` are provided only for discrete
quantum walk models.

## Example
```julia-repl
julia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));

julia> state = rand(16); state = sparse(state/norm(state));

julia> execute_single(qwe, state, 4)
16-element SparseVector{Float64,Int64} with 16 stored entries:
  [1 ]  =  0.37243
  [2 ]  =  0.402212
  [3 ]  =  0.356914
  [4 ]  =  0.0384893
  [5 ]  =  0.230443
  [6 ]  =  0.0373444
  [7 ]  =  0.12092
  [8 ]  =  0.285178
  [9 ]  =  0.151519
  [10]  =  0.258755
  [11]  =  0.30374
  [12]  =  0.375624
  [13]  =  0.169741
  [14]  =  -0.0403198
  [15]  =  0.255573
  [16]  =  0.0344363

julia> execute_all_measured(qwe, state, 4)
4×5 Array{Float64,2}:
 0.273249  0.455568  0.308632  0.339199  0.429348
 0.20334   0.165956  0.188335  0.188466  0.150447
 0.244393  0.213254  0.378161  0.171268  0.323264
 0.279018  0.165221  0.124872  0.301066  0.0969412

julia> execute(qwe, state, 4, measure=true, all=true)
4×5 Array{Float64,2}:
 0.273249  0.455568  0.308632  0.339199  0.429348
 0.20334   0.165956  0.188335  0.188466  0.150447
 0.244393  0.213254  0.378161  0.171268  0.323264
 0.279018  0.165221  0.124872  0.301066  0.0969412
```

## Adjusting model to `QWEvolution`

The `QWEvolution` requires an implementation of `evolve`, `measure` and `check_qwdynamics`.
Instead of implementing purely quantum walk, we will implement simple random walk,
which still fits our considerations.

We create an  `AbstractStochastic` supertype, in case someone would prefer to make different
stochastic evolution (for example change the stochastic matrix). Note we skipped
some assertion checking for readability. Furthermore note we have defined two
versions of `measure`: in most cases measuring only part of `vertices` are faster
than making full measurement.

```julia
abstract type AbstractStochastic <: QWModelDiscr end

struct UniformStochastic{G<:SimpleGraph} <: AbstractStochastic
  graph::G
end

UniformScaling(digraph::G) where G= UniformStochastic{G}(digraph)

function check_qwdynamics(::Type{QWEvolution},
                          abs_stoch::UniformStochastic,
                          parameters::Dict{Symbol,Any})
  @assert :stochastic ∈ keys(parameters) "parameters needs to have key stochastic"
  n = nv(graph(abs_stoch))
  @assert isa(parameters[:stochastic], SparseMatrixCSC{<:Real}) "value for :stochastic needs to be sparse matrix with real numbers"
  @assert size(parameters[:stochastic], 1) == size(parameters[:stochastic], 2) "Stochastic matrix needs to be square stochastic matrix"
  @assert mapslices(sum, parameters[:stochastic], 1)[1,:] ≈ ones(n) "Stochastic matrix needs to be square stochastic matrix of order graph"
end

function stochastic_matrix(g::SimpleGraph)
  a = adjacency_matrix(g)
  a*spdiagm(mapslices(x->1/sum(x), a, 1)[1,:])
end

function QWEvolution(stoch::AbstractStochastic)
   parameters = Dict{Symbol,Any}(:stochastic => stochastic_matrix(graph(stoch)))
   QWEvolution(stoch, parameters)
end

function stochastic_evolution(s::SparseMatrixCSC{T}, v::Vector{T}) where T<:Real
  s*v
end

function evolve(qws::QWDynamics{<:AbstractStochastic}, state)
  stochastic_evolution(parameters(qws)[:stochastic], state)
end

function measure(::QWDynamics{<:AbstractStochastic}, state::Vector{<:Real})
   return state
end

function measure(::QWDynamics{<:AbstractStochastic},
                 state::Vector{<:Real},
                 vertices::Vector{Int})
   return state[vertices]
end
```

Now we can make a pure walk evolution.

```julia-repl
julia> dynamic = QWEvolution(UniformStochastic(smallgraph(:bull)))
QuantumWalk.QWEvolution{UniformStochastic{LightGraphs.SimpleGraphs.SimpleGraph{Int64}}}(UniformStochastic{LightGraphs.SimpleGraphs.SimpleGraph{Int64}}({5, 5} undirected simple Int64 graph), Dict{Symbol,Any}(Pair{Symbol,Any}(:stochastic,
  [2, 1]  =  0.5
  [3, 1]  =  0.5
  [1, 2]  =  0.333333
  [3, 2]  =  0.333333
  [4, 2]  =  0.333333
  [1, 3]  =  0.333333
  [2, 3]  =  0.333333
  [5, 3]  =  0.333333
  [2, 4]  =  1.0
  [3, 5]  =  1.0)))

julia> println(execute_single(dynamic, fill(1./5, 5), 5))
[0.186831, 0.313169, 0.313169, 0.0934156, 0.0934156]
```

Note that continuous walks requires time argument in `evolution` function, as an example consider  [CTQW model](ctqw.md).

## Documentation

Following functions are connected to the dynamics. Note that since `QWEvolution`
is a default subtype of `QWDynamics`, most of the functions are defined for
the last type.
```@index
Order = [:type, :function]
Modules = [QuantumWalk]
Pages   = ["quantum_walk.md"]
```

### Full docs

```@docs
QWEvolution
check_qwdynamics(::Any)
evolve(::Any)
execute(::QWDynamics, ::Any, ::Real)
execute_all(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)
execute_all_measured(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)
execute_single(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)
execute_single_measured(::QWDynamics, ::Any, ::Real)
measure(::Any)
```
