using Documenter
include("../src/QuantumWalk.jl")
using QuantumWalk, LightGraphs

# same for contributing and license
cp(normpath(@__FILE__, "../../LICENSE.md"), normpath(@__FILE__, "../src/license.md"); remove_destination=true)



makedocs(
    modules     = [QuantumWalk],
    format      = :html,
    sitename    = "QuantumWalk",
    clean       = true,
    doctest     = true,
    checkdocs   = :exports,
    assets 	= ["assets/logo.ico"],
    pages       = Any[
		"Home"				=> "index.md",
		"Type hierarchies"	=> "type_hierarchy.md",
    		"Dynamics"		=> Any[
						"Quantum walk evolution"=> "quantum_walk.md",
						"Quantum search"        => "quantum_search.md"],
		"Walk models"         => Any[
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
