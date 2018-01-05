module QuantumWalk
using Expokit
using LightGraphs
using Optim

export
    initial_state,
    evolve,
    measure,
    check_qwsearch,
    check_qwevolution

```@meta
CurrentModule = QuantumWalk
```

"""
    QuantumWalk

An package for quantum walk and quantum search simulation.

The packaged provides hierarchy of Quantum walk models and their numerical description together
with general function for quantum walk simulation and quantum search evolution. In
particular CTQW and Szegedy walk models are implemented as an example of continuous
and discrete walk models.

For both continuous and discrete model quantum walk simulator is implemented and
function finding optimal measurement time for quantum search function. For discrete
walk evolution various optimization may be chosen.

Full documentation is available in GitHub pages.

"""
QuantumWalk

"""
    measure(qwevolution, state[, vertices])

Measure `state` according to model from quantum walk evolution `qwevolution`.
If `vertices` is provided,
probabilities of given vertices should be provided. Otherwise full probability
distribution should be provided. Output should be always
of type Array{Float64}.
The behaviour strongly depends on
model of `qwe`. For concrete `model` and `qwevolution` description please type
`?measure(qwevolution{model})`,
for example for `CTQW` and `QWSearch` write `?measure(QWSearch{CTQW})`.

Details concerning implementing `measure` for own models can be found in GitHub pages.
"""
measure

"""
    evolve(qwevolution{<:QWModelDiscr}, state)
    evolve(qwevolution{<:QWModelCont}, state, time)

Evolve `state` according to `qwevolution`. `time` should be provided
if model is continuous, otherwise one-step evolution should be performed. Type returned
should be the same as type of `state`. The behaviour strongly depends on
`model` of `qwevolution`. For concrete `model` description please type
`?evolve(qwevolution{model})`,
for example for `CTQW` and `QWSearch` write `?evolve(QWSearch{CTQW})`.

Details concerning implementing `evolve` for own models can be found in GitHub pages.
"""
evolve


"""
    check_qwevolution(model, parameters)

Checks whetver combination of `model` and `parameters` creates valid
quantum walk simulator.

Details concerning implementing `check_qws` for own models can be found in GitHub pages.

"""
check_qwevolution

include("type_hierarchy.jl")
include("dynamics.jl")

# dynamics
include("qwsearch/qwsearch.jl")
include("qwevolution/qwevolution.jl")

# models
include("ctqw/ctqw.jl")
include("szegedy/szegedy.jl")





end
