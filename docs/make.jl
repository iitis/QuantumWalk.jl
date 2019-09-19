using Documenter
#include("../src/QuantumWalk.jl")
using QuantumWalk, LightGraphs
using SparseArrays,Arpack,LinearAlgebra

# same for contributing and license
cp(normpath(@__FILE__, "../../LICENSE.md"), normpath(@__FILE__, "../src/license.md"), force=true)



makedocs(
    modules     = [QuantumWalk],
    format      = Documenter.HTML(assets = ["assets/logo.ico"]),
    sitename    = "QuantumWalk",
    clean       = true,
    doctest     = true,
    checkdocs   = :exports,
    pages       = Any[
		"Home"             => "index.md",
		"Type hierarchies" => "type_hierarchy.md",
    		"Dynamics"	   => Any[
                "Quantum walk evolution" => "quantum_walk.md",
				"Quantum search"         => "quantum_search.md"
                ],
			"Models"       => Any[
				"CTQW and CTQWDense" 	 => "ctqw.md",
				"Szegedy" 		         => "szegedy.md"
                ],
		"Contributing"	   => "contributing.md",
        	"Citing"	       => "citing.md",
		"Licence"	       => "license.md",
    ]
)

deploydocs(
    deps        = nothing,
    make        = nothing,
    repo        = "github.com/iitis/QuantumWalk.jl",
    target      = "build",
)


#rm(normpath(@__FILE__, "src/license.md"))
