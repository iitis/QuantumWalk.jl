## New dynamics

The main purpose of the package is to provide easy extendability of the code. As
Quantum walk models needs to be adjusted to existing dynamics, the key is to defined
an describe dynamic. As an example we propose an example of simple dynamic determining
the period of the model.

```julia
struct QWPeriod{T} <: QWDynamics{T}
  model::T
  parameters::Dict{Symbol,Any}

  function QWPeriod(model::T,
                    parameters::Dict{Symbol}) where T<:QWModelDiscr
    check_qwdynamics(QWPeriod, model, parameters)
    new{T}(model, parameters)
  end
end

function determine_period(qwp::QWPeriod,
                          init_state,
                          state_diff_val::Real,
                          tmax::Int=nv(graph(qwp)))
  state = evolve(qwp, init_state)
  for t=1:tmax
    if state_diff(qwp, state, init_state) < state_diff_val
      return t
    end
    state = evolve(qwp, state)
  end
  return -1
end

function QWPeriod(szegedy::AbstractSzegedy)
  operators = QuantumWalk.szegedy_walk_operators(szegedy)
  parameters = Dict{Symbol,Any}(:operators => operators)
  QWPeriod(szegedy, parameters)
end
```

According to the definition above, the following function should be implemented for `Model`:
* `QWPeriod(model::Model,...)`,
* `check_dynamics(QWPeriod, model::Model, parameters::Dict{Symbol,Any})`,
* `evolve(qwp::QWPeriod{<:Model}, state)`,
* `state_diff(qwp::QWPeriod{<:Model}, state1::S, state2::S) where S`.
Note that for `Szegedy` function `evolve` is already implemented, and we can use
private function for `check_dynamics`. Furthermore `execute` family commands are
inherited from `QWDynamics`, which in this case is equivalent to execution of
`QWEvolution`.

The implementation for the Szegedy can have following form:
```julia
function QWPeriod(szegedy::AbstractSzegedy)
  operators = QuantumWalk.szegedy_walk_operators(szegedy)
  parameters = Dict{Symbol,Any}(:operators => operators)
  QWPeriod(szegedy, parameters)
end

function check_qwdynamics(::Type{QWPeriod}, szegedy::AbstractSzegedy, parameters::Dict{Symbol})
  QuantumWalk.check_szegedy(szegedy, parameters)
end

function state_diff(qwp::QWPeriod{<:AbstractSzegedy},
                    state1::SparseVector{T},
                    state2::SparseVector{T}) where T<:Number
  1-abs(sum(state1.*conj.(state2)))
end
```

Thanks to the code above we can check the periodicity for the `Szegedy` walk.
```julia
julia> n = 20
20

julia> qwp = QWPeriod(Szegedy(barabasi_albert(n, 3)));

julia> determine_period(qwp, sparse(fill(1/n, n^2)), 0.01)
1

julia> state = sparse(randn(n^2)); state /= norm(state);

julia> determine_period(qwp, state, 0.05, 8000)
401
```
