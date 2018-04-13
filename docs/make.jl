using Documenter
include("../src/QuantumWalk.jl")
using QuantumWalk, LightGraphs

# same for contributing and license
cp(normpath(@__FILE__, "../../LICENSE.md"), normpath(@__FILE__, "../src/license.md"); remove_destination=true)



makedocs(
    modules     = [QuantumWalk],
    format      = :html,
    sitename    = "QuantumWalk",
    doctest     = true,
    checkdocs   = :exports,
    assets 	= ["assets/logo.ico"],
    pages       = Any[
		"Home"				=> "index.md",
		"Type hierarchy" 		=> "type_hierarchy.md",
		"Examplary dynamics"		=> Any[
						"Quantum walk evolution"=> "quantum_walk.md",
						"Quantum search"        => "quantum_search.md"],
		"Examplary models"             	=> Any[
						"CTQW model" 		=> "ctqw.md",
						"Szegedy model" 	=> "szegedy.md"],
		"New dynamics"     	=> "new_dynamics.md",
        "Contributing"		=> "contributing.md",
        "Citing"	       	=> "citing.md",
		"Licence"			=> "license.md",
    ]
)

deploydocs(
    deps        = nothing,
    make        = nothing,
    repo        = "github.com/QuantumWalks/QuantumWalk.jl",
    target      = "build",
    julia       = "0.6",
    osname      = "linux"
)


#rm(normpath(@__FILE__, "src/license.md"))
