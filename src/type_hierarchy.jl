export
  QWModel,
  QWModelCont,
  QWModelDiscr,
  QWDynamics,
  graph,
  model,
  parameters

"""
    QWModel

Abstract supertype of all quantum walk models.
"""
abstract type QWModel end

"""
    graph(model)

Returns `graph` element of `model`.

```@docs
julia> ctqw = CTQW(CompleteGraph(4))
QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency)

julia> graph(ctqw)
{4, 6} undirected simple Int64 graph

```
"""
graph(model::QWModel) = model.graph

"""
    QWModelCont

Abstract supertype of all continuous quantum walk models.
"""
abstract type QWModelCont <: QWModel end
"""
    QWModelDiscr

Abstract supertype of all discrete quantum walk models.
"""
abstract type QWModelDiscr <: QWModel end

"""
    QWDynamics{T<:QWModel}

Abstract supertype of all dynamics on quantum walk models.
"""
abstract type QWDynamics{T<:QWModel} end

"""
    graph(qwd)

Returns `graph` element of `model` from `qwd`. Equivalent to
`graph(model(qwd))`.

```@docs
julia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])
QuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,
  [1, 1]  =  1.0+0.0im
  [2, 1]  =  0.333333+0.0im
  [3, 1]  =  0.333333+0.0im
  [4, 1]  =  0.333333+0.0im
  [1, 2]  =  0.333333+0.0im
  [3, 2]  =  0.333333+0.0im
  [4, 2]  =  0.333333+0.0im
  [1, 3]  =  0.333333+0.0im
  [2, 3]  =  0.333333+0.0im
  [4, 3]  =  0.333333+0.0im
  [1, 4]  =  0.333333+0.0im
  [2, 4]  =  0.333333+0.0im
  [3, 4]  =  0.333333+0.0im)), 0.0)

julia> graph(qss)
{4, 6} undirected simple Int64 graph
```
"""
graph(qwd::QWDynamics) = graph(qwd.model)

"""
    model(qwd)

Returns `model` element of `qwd`.

```@docs
julia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])
QuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,
  [1, 1]  =  1.0+0.0im
  [2, 1]  =  0.333333+0.0im
  [3, 1]  =  0.333333+0.0im
  [4, 1]  =  0.333333+0.0im
  [1, 2]  =  0.333333+0.0im
  [3, 2]  =  0.333333+0.0im
  [4, 2]  =  0.333333+0.0im
  [1, 3]  =  0.333333+0.0im
  [2, 3]  =  0.333333+0.0im
  [4, 3]  =  0.333333+0.0im
  [1, 4]  =  0.333333+0.0im
  [2, 4]  =  0.333333+0.0im
  [3, 4]  =  0.333333+0.0im)), 0.0)

julia> model(qss)
QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency)
```
"""
model(qwd::QWDynamics) = qwd.model

"""
    parameters(qwd)

Returns `parameters` element of `qwd`.

```@docs
julia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])
QuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,
  [1, 1]  =  1.0+0.0im
  [2, 1]  =  0.333333+0.0im
  [3, 1]  =  0.333333+0.0im
  [4, 1]  =  0.333333+0.0im
  [1, 2]  =  0.333333+0.0im
  [3, 2]  =  0.333333+0.0im
  [4, 2]  =  0.333333+0.0im
  [1, 3]  =  0.333333+0.0im
  [2, 3]  =  0.333333+0.0im
  [4, 3]  =  0.333333+0.0im
  [1, 4]  =  0.333333+0.0im
  [2, 4]  =  0.333333+0.0im
  [3, 4]  =  0.333333+0.0im)), 0.0)

julia> parameters(qss)
Dict{Symbol,Any} with 1 entry:
  :hamiltonian => …

```
"""
parameters(qwd::QWDynamics) = qwd.parameters
