function QWEvolution(qwmodel::AbstractDiscretizedQWModel,
                     parameters::Dict{Symbol,Any},
                     check::Bool=true)
    qwe_internal = QWEvolution(model(qwmodel))
    params = Dict{Symbol,Any}(:qwd_internal => qwe_internal)
    QWEvolution(qwmodel, params, check=check)
end

function QWSearch(qwmodel::AbstractDiscretizedQWModel,
                  marked::Vector{Int},
                  penalty::Float64,
                  check=true)
    qss_internal = QWSearch(model(qwmodel), marked, penalty, check=check)
    params = Dict{Symbol,Any}(:qwd_internal => qss_internal)
    QWSearch(qwmodel, params, marked, penalty, check=check)
end

function expected_runtime(qws:: QWSearch{<:AbstractDiscretizedQWModel},
                          qstate::QSearchState)
    true_time = real_runtime(model(qws), runtime(qstate)) + penalty(qws)
    expected_runtime(true_time, sum(state.probability))
end

function dynamics_internal(qwd::QWDynamics{<:AbstractDiscretizedQWModel})
    return parameters(qwd)[:qwd_internal]
end

function initial_state(qws:: QWSearch{<:AbstractDiscretizedQWModel})
    initial_state(dynamics_internal(qwd))
end

function evolve(qws::QWSearch{<:AbstractDiscretizedQWModel}, state)
    evolve(dynamics_internal(qwd), state, granulation(model(qws)))
end

function measure(qws::QWSearch{<:AbstractDiscretizedQWModel}, state)
    measure(dynamics_internal(qwd), state, granulation(model(qws)))
end

function measure(qws::QWSearch{<:AbstractDiscretizedQWModel}, state, vertices::Vector{Int})
    measure(dynamics_internal(qwd), state, granulation(model(qws)))
end
