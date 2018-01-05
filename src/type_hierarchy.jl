export
  QWModel,
  QWModelCont,
  QWModelDiscr,
  QWDynamics,
  graph,
  model,
  parameters,

"""
    QWModel
"""
abstract type QWModel end

graph(model::QWModel) = model.graph

"""
    QWModelCont
"""
abstract type QWModelCont <: QWModel end
"""
    QWModelDiscr
"""
abstract type QWModelDiscr <: QWModel end

"""
    QWDynamics
"""
abstract type QWDynamics{T<:QWModel} end

"""
    graph
"""
graph(qwe::QWDynamics) = graph(qwe.model)

"""
    model
"""
model(qwe::QWDynamics) = qwe.model

"""
    parameters
"""
parameters(qwe::QWDynamics) = qwe.parameters
