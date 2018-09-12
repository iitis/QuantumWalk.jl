[![Build Status](https://travis-ci.org/QuantumWalks/QuantumWalk.jl.svg?branch=master)](https://travis-ci.org/QuantumWalks/QuantumWalk.jl)
[![Coverage Status](https://coveralls.io/repos/github/QuantumWalks/QuantumWalk.jl/badge.svg?branch=master)](https://coveralls.io/github/QuantumWalks/QuantumWalk.jl?branch=master)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://QuantumWalks.github.io/QuantumWalk.jl/latest)
# QuantumWalk

## Description

*QuantumWalk.jl* is a package for Julia programming language implementing models
of quantum continuous and discrete walks used for performing quantum spatial
search. It's main purpose is to provide general functionalities by crossing usage
of quantum models and applications implementations.

Currently the package provides implementation of
* Szegedy quantum walks `Szegedy` with abstract supertype `AbstractSzegedy`,
* continuous-time quantum walks `CTQW` and `CTQWDense` with abstract supertype `AbstractCTQW`,

and dynamics
* simple quantum walk `QWEvolution`,
* quantum spatial search `QWSearch`.

In particular for the last dynamic algorithm `maximize_quantum_search` finding optimal measure time are implemeneted. Note the function works in general for arbitrary discrete-time quantum walk. The results are not guaranteed for continuous-time quantum walk, as times is not discretized.

The package requires [LightGraphs.jl](https://github.com/JuliaGraphs/LightGraphs.jl), [Optim.jl](https://github.com/JuliaNLSolvers/Optim.jl) and [Expokit.jl](https://github.com/acroy/Expokit.jl).

## Installation

The package can be installed using `Pkg.clone` command as
```julia-repl
(v1.0) pkg> add QuantumWalk
```
All of the required modules will be installed automatically.

## Exemplary usage and citing
Our package was already used in papers concerning quantum attacks
* Adam Glos, Jarosław Adam Miszczak. `Impact of the malicious input data modification on the efficiency of quantum algorithms.' arXiv preprint arXiv:[1802.10041](https://arxiv.org/abs/1802.10041) (2018).

In case of citing, please use the following BibTeX form:

```tex
@misc{glos2018quantumwalkjl,
  author       = {Adam Glos and Jaros{\l}aw Adam Miszczak},
  title        = {{QuantumWalks/QuantumWalk.jl}},
  year         = {2018},
  url          = {https://github.com/QuantumWalks/QuantumWalk.jl}
}
```
