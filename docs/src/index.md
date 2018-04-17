

# Welcome to QuantumWalk.jl

*QuantumWalk.jl* is a package providing general functionalities and implementations of quantum walks. The package uses the Julia's type hierarchy to produce general functions working on at least large collection of quantum walk models.

# Why?

Since the very first paper defining quantum walk, plenty of quantum walk models were proposed. This includes continuous-time quantum walk, Szegedy quantum walk, coined quantum walk, stochastic quantum walk or flip-flop quantum walk, to name a few. Most of the models have the same applications as for example spatial search or transport. Furthermore models are compared by general properties such as localization, propagation or trapping.

The purpose of the package is not to provide an implementations of all models, as this is simply impossible due to quantum walk theory progress. Our aim is to provide cross functionality: implementing properly single model allows using already implemented dynamics such as spatial search or pure walk evolution. Contrary, if we came out with some interesting general quantum walk property, we can use the package for analysing already existing models.

# How?

The package implements two independent type hierarchies: one for quantum walk model, one for quantum dynamics. If possible, the quantum dynamics is defined iff proper functions for quantum walk models are defined. For example if we provide `evolve`, `measure` and `check_qwdynamics` methods we can use the model for simulating pure walk evolution. Similarly we need `initial_state`, `evolve`, `measure` and `check_qwdynamics` for quantum spatial search dynamics.

Currently defined quantum walk models are presented in section *Exemplary models*, while exemplary quantum dynamics are presented in *Exemplary models*.

# Can I contribute?

Yes, You can! As there are simply to many models and quantum dynamics we cannot deal with such on our own. The details concerning contribution can be found in *Contributing* section.
