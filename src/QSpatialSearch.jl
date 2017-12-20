module QSpatialSearch
using Expokit
using LightGraphs
using Optim

export
    initial_state,
    evolve,
    measure


"""
TODO: Documentation for QSpatialSearch



"""
QSpatialSearch

"""
    initial_state
"""
initial_state

"""
    measure
"""
measure

"""
    evolve
"""
evolve


include("type_hierarchy.jl")
include("general_search_util.jl")
include("continuous_search.jl")
include("discrete_search.jl")
include("qwalk_simulator.jl")

include("ctqw/ctqw.jl")
include("szegedy/szegedy.jl")




end
