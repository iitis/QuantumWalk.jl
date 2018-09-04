export
  QWModel,
  QWModelCont,
  QWModelDiscr,
  QWDynamics,
  graph,
  model,
  parameters

"""
    QWModel

Abstract supertype of all quantum walk models.
"""
abstract type QWModel end

"""
    graph(model)

Returns `graph` element of `model`.
"""
graph(model::QWModel) = model.graph

"""
    QWModelCont

Abstract supertype of all continuous quantum walk models.
"""
abstract type QWModelCont <: QWModel end
"""
    QWModelDiscr

Abstract supertype of all discrete quantum walk models.
"""
abstract type QWModelDiscr <: QWModel end

"""
    QWDynamics

Abstract supertype of all dynamics on quantum walk models.
"""
abstract type QWDynamics{T<:QWModel} end

"""
    graph(qwd)

Returns `graph` element of `model` from dynamics `qwd`. Equivalent to
`graph(model(qwd))`.
"""
graph(qwd::QWDynamics) = graph(qwd.model)

"""
    model(qwd)

Returns `model` element of dynamics `qwd`.
"""
model(qwd::QWDynamics) = qwd.model

"""
    parameters(qwd)

Returns `parameters` element of dynamics `qwd`.
"""
parameters(qwd::QWDynamics) = qwd.parameters
