export
   QWEvolution
"""
    QWEvolution(model, parameters, check)

Type describing standard quantum walk evolution. `check_qwdynamics` is executed if and only iff `check` is true.

 Needs implementation of
* `evolve(::QWEvolution{<:QWModelDiscr}, state)` or `evolve(::QWEvolution{<:QWModelCont}, state, time::Real)`
* `measure(::QWEvolution, state)`
* `check_qwdynamics(QWEvolution, ::QWModel, parameters::Dict{Symbol})`
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
                       parameters::Dict{Symbol};
                       check::Bool=false) where T<:QWModel
    if check
       check_qwdynamics(QWEvolution, model, parameters)
    end
    new{T}(model, parameters)
  end
end

function check_qwdynamics(qwe::QWEvolution)
  check_qwdynamics(QWEvolution, model(qwe), parameters(qwe))
end
