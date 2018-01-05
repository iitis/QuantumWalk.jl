using Documenter
include("../src/QuantumWalk.jl")
using QuantumWalk, LightGraphs	

# same for contributing and license
println(pwd())
cp(normpath(@__FILE__, "../../LICENSE.md"), normpath(@__FILE__, "../src/license.md"); remove_destination=true)

makedocs(
    modules     = [QuantumWalk],
    format      = :html,
    sitename    = "QuantumWalk",
    doctest     = true,
    checkdocs   = :exports,
    assets 	= ["assets/logo.ico"],
    pages       = Any[
        "Basics"                       => "index.md",
        "Quantum walk evolution types" => "type_hierarchy.md",
        "Quantum search"               => "quantum_search.md",
        "Quantum walk simulator"       => "quantum_walk.md",
        "Examplary models"             => Any[
		"CTQW model" => "ctqw.md",
		"Szegedy model" => "szegedy.md"],
        "How to make your own model?"  => "own_model.md",
        "Licence"                      => "license.md",
        "Citing"                       => "citing.md",
        "Contributing"                 => "contributing.md"
    ]
)

deploydocs(
    deps        = nothing,
    make        = nothing,
    repo        = "github.com/ZKSI/QuantumWalk.jl",
    target      = "build",
    julia       = "0.6",
    osname      = "linux"
)


#rm(normpath(@__FILE__, "src/license.md"))
