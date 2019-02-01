__precompile__()

module QuantumWalk

using Expokit
using LightGraphs
using Optim

using LinearAlgebra
using SparseArrays
using Arpack

export
	AbstractCTQW,
	AbstractSzegedy,
	CTQW,
    CTQWDense,
	QSearchState,
	QWDynamics,
	QWEvolution,
	QWModel,
	QWModelCont,
	QWModelDiscr,
	QWSearch,
	QuantumWalk,
	Szegedy,
	check_qwdynamics,
	evolve,
	execute,
	execute_all,
	execute_all_measured,
	execute_single,
	execute_single_measured,
	expected_runtime,
	graph,
	initial_state,
	marked,
	matrix,
	maximize_quantum_search,
	measure,
	model,
	parameters,
	penalty,
	probability,
	runtime,
	sqrtstochastic,
	state



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

Full documentation is available in [GitHub pages](https://quantumwalks.github.io/QuantumWalk.jl/latest/).

"""
QuantumWalk


include("type_hierarchy.jl")
include("dynamics.jl")
include("utils/utils_stochastic.jl")


include("qwdynamics/qwdynamics_import.jl")
include("qwmodels/qwmodels_import.jl")


end
