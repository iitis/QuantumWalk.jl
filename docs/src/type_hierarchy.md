```@meta
DocTestSetup = quote
   using QuantumWalk, LightGraphs
end
```

## Type hierarchy

The package consists of two main type hierarchies: quantum walk model hierarchy,
which is simply a description of the quantum walk model, and quantum walk dynamics,
which are used for quantum walk analysis or simulation. The first one should in general be small, and should consist only of general parameters used in most of the models. Second one
should possess all information needed for efficient simulation/analysis. For example
`CTQW` model should consist of graph, on which the evolution is made and *label*
which implies if adjacency or Laplacian matrix is used. Contrary `QWEvolution{CTQW}` should consist of Hamiltonian used for evolution.

## Quantum walk models hierarchy

The main supertype is `QWModel`. As typically discrete and continuous evolution
are simulated and analysed using different techniques, `QWModelCont` and
`QWModelDiscr` are its direct subtypes. Furthermore every model have
its direct abstract supertype, which is at least *similar* in the sense of
implemented function to the supertype.

Any instance of quantum walk model consists of graph on which evolution is
made. Such graph can be accessed via `graph` function. Hence an typical definition
of quantum walk model type takes the from
```julia
struct Model <: AbstractModel
   graph::Graph
   ...
   function Model(graph::Graph, ...)
      ...
      new(graph, ...)
   end
end
```

At the moment `CTQW` and `Szegedy` walks are implemented. Note that arbitrary
quantum walk model should consist of `measure`, `evolve` and `check_qwdynamics`
for basic pure walk simulation implemented in `QWEvolution`.

## Quantum dynamics hierarchy

The main supertype is `QWDynamics`. As the algorithms and analysis usually differs strongly,
subtypes of `QWDynamics` should be mostly a composite types.

Any `QWDynamics` should consist of at least two parameters: `model::QWModel`, which is a
quantum walk model, and `parameters::Dict{Symbol,Any}`, which is a dictionary consisting of values
needed for `model`. Elements are accessible via function with the same name. In order to check correctness, `check_qwdynamics` should always
be executed in the constructor. Typical quantum walk dynamics are defined as
follows.
```julia
struct Dynamics{T} <: QWDynamics{T}
  model::T
  parameters::Dict{Symbol}
  ...

  function Dynamics(model::T, parameters::Dict{Symbol}, ...) where T<:QWModel
     ...
     check_qwdynamics(Dynamics, model, parameters, ...)
     ...
     new(model, parameters, ...)
  end
end
```

At the moment `QWEvolution` for pure walk evolution and `QWSearch` for quantum spatial search are implemented.
All dynamics provides `execute` functionality, together with its variation.


## Documentation

Following functions are connected to the presented topic:
```@index
Order = [:type, :function]
Modules = [QuantumWalk]
Pages   = ["type_hierarchy.md"]
```

### Full docs

```@docs
QWDynamics{T<:QWModel}
QWModel
QWModelCont
QWModelDiscr
graph(::QWModel)
graph(::QWDynamics)
model(::QWDynamics)
parameters(::QWDynamics)
```
