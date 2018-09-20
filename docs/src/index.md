

## Welcome to QuantumWalk.jl

*QuantumWalk.jl* is a package for Julia programming language, which provides a framework for implementing and analyzing quantum walks. The package provides general implementation of functions relevant for all models of quantum walks. To achieve this, it utilizes the Julia's type hierarchy to implement general functions working on large collection of quantum walk models.

## Motivation

Since the very first paper defining quantum walk, plenty of quantum walk models were proposed. This includes continuous-time quantum walk, Szegedy quantum walk, coined quantum walk, stochastic quantum walk, and flip-flop quantum walk, to name a few. Most of the models have the same applications, including spatial search and transport. Furthermore, models can be compared by analyzing their general properties such as localization, propagation, and trapping.

The purpose of the package is not to provide implementations of all models, as this is simply impossible due to the rapid progress in the theory of quantum walks. We aim to provide functionality common for all models. Thanks to this, by providing the implementation details of a particular single model, the user can execute the types of dynamics defined by the package, including spatial search and walk evolution. On the other hand, if one is interested in some property relevant for a general quantum walk, the package can be used for analyzing already existing models.

## Package structure

The package structure is based on two independent type hierarchies: the first one for operating on walk models, and second for defining dynamics. The dynamic is defined if the appropriate functions for the model are defined. For example, if one provides `evolve`, `measure`, and `check_qwdynamics` methods for the newly defined model, the package can be used to simulate the evolution of this model. If additionally, the user provides `initial_state` method, the package can be used for executing quantum spatial search dynamics.

Models of quantum walks currently implemented in the package are presented in section *Models*, while the types of dynamics provided by the package are decried in section *Dynamics*. Simple usage examples can be found on [our GitHub repository](https://github.com/QuantumWalks/QuantumWalk.jl/tree/master/tutorials).

## Can I contribute?

Yes, You can! There are simply to many models and quantum dynamics, we cannot deal with all of them. If you can provide an implementation of a new model, we would be happy to include it in our package. The details can be found in section *[Contributing](contributing.html)*.

An example of how to define new dynamics or quantum walk model can be found in tutorial directory on [our GitHub repository](https://github.com/QuantumWalks/QuantumWalk.jl/tree/master/tutorials).
