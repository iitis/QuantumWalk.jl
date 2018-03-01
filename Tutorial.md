# Introduction

Package ```QuantumWalk``` enables you to simulate various types of quantum
dynamics which can be describe using quantum walk, ie. quantum evolution with a
discrete set of states. Such evolution can be understood as the evolution on a
graph.

The simplest example of quantum dynamics on a graph is quantum walk. In this
case one is interested in the evolution of the system described by the
probability distribution on the space of vertices. Another example is quantum
spatial search, where one is interested in the probability of finding one of the
marked nodes and the time required to visit it.

# Type hierarchy

In ```QuantumWalk``` package the dynamics is represented by the abstract type
```QWDynamics```. This type has two subtypes ```QWEvolution```, representing the
simulation of a quantum walk, and ```QWSearch```, representing a quantum
spatial search. Both types are parametrized by the ```QWModel```, which can be
used to represent the flavor of quantum walk used in the dynamic.

# Basic usage

Let us assume that we need to simulate the continuous-time evolution on a
complete graph of dimension

```julia
n = 5
```

The first step is to construct the graph using ```LightGraphs``` package.

```julia
g = CompleteGraph(n)
```

Next, one has to build the model of quantum walks used in the dynamics. In this
case we use ```CTQW``` type from ```QuantumWalk``` package.

```julia
ctqw = CTQW(g)
```

This object can be used to build the quantum dynamics based on continuous-time
quantum walk on the given graphs
```julia
ctqw_sim = QWEvolution(ctqw)
```
This dynamics, which is in this case is of type ```QWEvolution```, can be used
to simulate quantum walk. To achieve this one has to define an initial state
```julia
init = zeros(n)
init[3] = 1
```
and execute the simulation
```
evolve(ctqw_sim, init, 2.0)
```

Alternatively, if one is interested in executing quantum search using the
continuous-time evolution, the ```ctqw``` can be used to build dynamics
representing such procedure
```julia
ctqw_qss = QWSearch(ctqw, [1,3])
```
Here the last argument is used to describe the set of marked elements.

The search procedure is executed as
```julia
evolve(ctqw_qss, initial_state(ctqw_qss), 2.0)
```

# Custom types

It is possible to extend the package functionality by constructing data types
derived from abstract types, which represent basic models of quantum walks. For
example, the following declaration could be used to introduce quantum stochastic
walks

```julia
structure StochasticCTQW <: AbstractCTQW
  graph::Graph
  matrix::Symbol
  regime::Symbol
end

```   
