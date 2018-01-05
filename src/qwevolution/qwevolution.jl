export
   QWEvolution
"""
    QWEvolution(model, parameters)

Type describing standard quantum walk evolution. Needs implementation of
* `evolve(::QWEvolution{<:QWModelDiscr}, state)` or `evolve(::QWEvolution{<:QWModelCont}, state, time::Real)`
* `measure(::QWEvolution, state)`
* `check_qwevolution(::QWModelDiscr, parameters::Dict{Symbol})`
* proper constructors.

Offers functions
* `execute`
* `execute_single`
* `execute_single_measured`
* `execute_all`
* `execute_all_measured`
"""
struct QWEvolution{T} <: QWDynamics{T}
  model::T
  parameters::Dict{Symbol}

  function QWEvolution(model::T,
                       parameters::Dict{Symbol}) where T<:QWModel
    check_qwevolution(model, parameters)
    new{T}(model, parameters)
  end
end
