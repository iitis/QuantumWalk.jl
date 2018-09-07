using QuantumWalk
using LightGraphs
using Test
using LinearAlgebra,SparseArrays

macro test_no_error(ex)
    quote
        try
            $(esc(ex))
            true
        catch
            false
        end
    end
end

include("ctqw.jl")
include("szegedy.jl")
include("qwsearch.jl")
include("qwevolution.jl")
include("type_hierarchy.jl")
include("maximizing_function.jl")
