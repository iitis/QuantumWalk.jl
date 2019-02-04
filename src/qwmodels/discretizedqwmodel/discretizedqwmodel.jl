export
   AbstractDiscretizedQWModel,
   DiscretizedQWModel,
   granulation,
   realtoint_runtime,
   inttoreal_runtime,
   dynamics_internal

"""
    AbstractDiscretizedQWModel

Abstract discretization of quantum walk model. It represents discrete
version of an continuous time quantum walk, where each time step of value represents
some (not necessarily 1.) time step. Note that the original model needs
to be Markovian, i.e. the operation cannot depend on current time, only of
its length.

Warning: performing large number of steps may be more error-prone comparing
to original continuous-time model. For high precision calculation we advise
to compare the results with the original qwdynamics, in which it is usually a
single-step calculation.
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

function DiscretizedQWModel(qwmodel::S,
                            granulation::T=1.) where{S,T}
    DiscretizedQWModel{S,T}(qwmodel, granulation)
end

function model(discrqwmodel::AbstractDiscretizedQWModel)
    discrqwmodel.qwmodelcont
end

"""
    granulation(discrqwmodel)

Outputs `granulation` of the discretezing model.
"""
function granulation(discrqwmodel::AbstractDiscretizedQWModel)
    discrqwmodel.granulation
end

function granulation(qwdynamics_discr::QWDynamics{<:AbstractDiscretizedQWModel})
    granulation(qwdynamics_discr.model)
end

"""
    inttoreal_runtime(discrqwmodel, time)

Corrects `time` by granulation of the model.
"""
function inttoreal_runtime(qwmodel::DiscretizedQWModel, runtime::Int)
    granulation(qwmodel)*runtime
end

"""
    realtoint_runtime(discrqwmodel, time[, rounding])

Corrects `time` by granulation of the model. Converge to `Int` by taking the
`rounding`, which defaults to `x->ceil(Int, x)`.
"""
function realtoint_runtime(qwmodel::DiscretizedQWModel,
                    runtime::Real,
                    rounding_method::Function= x->Int(ceil(x)))
    rounding_method(runtime/granulation(qwmodel))
end

include("discretizedqwmodel_dynamics.jl")
include("discretizedqwmodel_evolution.jl")
