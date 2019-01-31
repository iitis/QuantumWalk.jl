export
   AbstractDiscretizedQWModel,
   DiscretizedQWModel,
   granulation,
   real_runtime,
   dynamics_internal

"""
    AbstractDiscretizedQWModel

Abstract discretization of quantum walk model. It represents discrete
version of an continuous time quantum walk, where each time step of value represents
some (not necessarily 1.) time step.
"""
abstract type AbstractDiscretizedQWModel <: QWModelDiscr end

"""
    DiscretizedQWModel(qwmodelcont, granulation)

Default struct of `AbstractDiscretizedQWModel`. `qwmodelcont` is discretized model,
and `granulation` reflects the true value of 1 time step.
"""
struct DiscretizedQWModel{T<:QWModelCont,S<:Real} <: AbstractDiscretizedQWModel
    qwmodelcont::T
    granulation::S
    function DiscretizedQWModel{T,S}(qwmodel::T, granulation::S) where {T<:QWModelCont,S<:Real}
        @assert granulation > 0 "granulation needs to be positive"
        new{T,S}(qwmodel, granulation)
    end
end

function DiscretizedQWModel(qwmodel::QWModelCont)
    DiscretizedQWModel(qwmodel, 1.)
end

function model(discrqwmodel::AbstractDiscretizedQWModel)
    DiscretizedQWModel.qwmodelcont
end

function granulation(discrqwmodel::AbstractDiscretizedQWModel)
    DiscretizedQWModel.granulation
end

function real_runtime(qwmodel::DiscretizedQWModel, time::Int)
    granulation(qwmodel)*time
end


include("discretizedqwmodel_dynamics.jl")
