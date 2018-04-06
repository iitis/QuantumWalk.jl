# Welcome to QuantumWalk.jl

*QuantumWalk.jl* is a package which provides general functionalities and implementations of quantum walks. The package uses the Julia's typ hierarchy to produce general functions working on at least large collection of quantum walk models.

## Why?

Since the very first paper proposing quantum walk, plenty of quantum walk models were proposed. This includes continuous-time quantum walk, Szegedy quantum walk, coined quantum walk, stochastic quantum walk or flip-flop quantum walk, to name a few. Furthermore most of the models have very similar application as for example spatial search or transport. Moreover models are usually compared by their properties such as localization, propagation or trapping.

The purpose of the package is not to provide an implementations of all models, as this is simply impossible due to quantum walk theory progress. Our aim is to provide cross functionality: implementing properly single model, we may use already implemented dynamics such as search or pure walk. Contrary, if we came out with some interesting general quantum walk property, we can use the package for analysing already existing models.

## How?

The package implements two independent type hierarchies: one for quantum walk model, one for quantum dynamics. If possible, the quantum dynamics is defined iff proper functions are defined. For example if we provide `evolve`, `measure` and `check_qwevolution` methods we can use the model for simulating pure walk evolution. Similarly we need `initial_state`, `evolve`, `measure` and `check_qwevolution`.

Currently defined quantum walk models are presented in section *Examplary models*, while examplary quantum dynamics are presented in *Examplary models*.

## Why this way?

We understand we cannot do anything on our own. Understanding all of the simulations and improving them would require to much knowledge, especially when we think of how many analysis methods are available. That is way we propose the package, which (at least at the moment) *has nothing*, but *allows everything*. User can provide arbitrary analysis or arbitrary model implementation, maybe suitable for his research only, that is way the package *allows everything*. At the same time he can use easily already existing part of our code, as the package is mostly abstract, and this is way we say it *has nothing*.

## Can I contribute?

Yes, You can! As there are simply to many models and quantum dynamics we cannot deal with such on our own. The details concerning contribution can be found in *Contributing* section.
