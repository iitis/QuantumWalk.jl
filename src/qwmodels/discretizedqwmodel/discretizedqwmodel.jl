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
some (not necessarily 1.) time step. Note that the original model needs
to be Markovian, i.e. the operation cannot depend on current time, only of
its length.
"""
abstract type AbstractDiscretizedQWModel <: QWModelDiscr end

"""
    DiscretizedQWModel(qwmodelcont[, granulation])

Default struct of `AbstractDiscretizedQWModel`. `qwmodelcont` is discretized model,
and `granulation` reflects the true value of 1 time step. By default `granulation`
equals 1.
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

"""
    granulation(discrqwmodel)

Outputs `granulation` of the discretezing model.
"""
function granulation(discrqwmodel::AbstractDiscretizedQWModel)
    DiscretizedQWModel.granulation
end

"""
    real_runtime(discrqwmodel, time::Int)

Corrects `time` by granulation of the model.
"""
function real_runtime(qwmodel::DiscretizedQWModel, time::Int)
    granulation(qwmodel)*time
end


include("discretizedqwmodel_dynamics.jl")
