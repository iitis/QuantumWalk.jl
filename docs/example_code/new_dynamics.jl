using QuantumWalk

import QuantumWalk: check_qwdynamics, QWDynamics, Szegedy, AbstractSzegedy, QWModelDiscr

##

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

function check_qwdynamics(::Type{QWPeriod}, szegedy::AbstractSzegedy, parameters::Dict{Symbol})
  QuantumWalk.check_szegedy(szegedy, parameters)
end

function state_diff(qwp::QWPeriod{<:AbstractSzegedy},
                    state1::SparseVector{T},
                    state2::SparseVector{T}) where T<:Number
  1-abs(sum(state1 .* conj.(state2)))
end
##
n = 20
qwp = QWPeriod(Szegedy(barabasi_albert(n, 3)));
determine_period(qwp, sparse(fill(1/n, n^2)), 0.01)
state = sparse(randn(n^2)); state /= norm(state);
determine_period(qwp, state, 0.05, 8000)
