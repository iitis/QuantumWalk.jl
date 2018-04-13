using LightGraphs

module QuantumWalk
using Expokit
using LightGraphs
using Optim

export
    initial_state,
    evolve,
    measure,
    check_qwdynamics



"""
    QuantumWalk

An package for quantum walk and quantum search simulation.

The packaged provides hierarchy of Quantum walk models and their numerical description together
with general function for quantum walk simulation and quantum search evolution. In
particular `CTQW` and `Szegedy` walk models are implemented as an example of continuous
and discrete walk models.

For both continuous and discrete model quantum walk simulator is implemented and
function finding optimal measurement time for quantum search function. For discrete
walk evolution various optimization may be chosen.

Full documentation is available in GitHub pages.

"""
QuantumWalk

"""
    measure(qwdynamic, state[, vertices])

Measure `state` according to model from quantum walk evolution `qwdynamic`.
If `vertices` is provided,
probabilities of given vertices should be provided. Otherwise full probability
distribution should be provided. Output should be always
of type `Vector{Float64}`. The behaviour strongly depends on
arguments
"""
measure(::Any)

"""
    evolve(qwdynamic::QWDynamics{<:QWModelDiscr}, state)
    evolve(qwdynamic::QWDynamics{<:QWModelCont}, state, time)

Evolve `state` according to `qwdynamic`. `time` should be provided
if model is continuous, otherwise one-step evolution should be performed. Type returned
should be the same as type of `state`. The behaviour strongly depends on
arguments.
"""
evolve(::Any)


"""
    check_qwdynamics(dynamictype, model, ..., parameters)

Checks whetver combination of the arguments creates valid quantum walk dynamics.
The behaviour strongly depends on arguments.
"""
check_qwdynamics(::Any)



include("type_hierarchy.jl")
include("dynamics.jl")

# dynamics
include("qwsearch/qwsearch.jl")
include("qwevolution/qwevolution.jl")

# models
include("ctqw/ctqw.jl")
include("szegedy/szegedy.jl")

end
