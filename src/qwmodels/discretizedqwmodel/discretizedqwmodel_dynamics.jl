function QWEvolution(qwmodel::AbstractDiscretizedQWModel,
                     check::Bool=true)
    qwe_internal = QWEvolution(model(qwmodel))
    params = Dict{Symbol,Any}(:qwd_internal => qwe_internal)
    QWEvolution(qwmodel, params, check=check)
end

function QWSearch(qwmodel::AbstractDiscretizedQWModel,
                  marked::Vector{Int},
                  penalty::Float64,
                  check::Bool=true)
    qss_internal = QWSearch(model(qwmodel), marked, penalty, check=check)
    params = Dict{Symbol,Any}(:qwd_internal => qss_internal)
    QWSearch(qwmodel, params, marked, penalty, check=check)
end

function check_qwdynamics(T::Type{QWEvolution},
                          qwd_discr::AbstractDiscretizedQWModel,
                          params::Dict{Symbol}) #where T<:QWDynamics
    check_qwdynamics(T, model(qwd_discr), parameters(params[:qwd_internal]))
end

function check_qwdynamics(T::Type{QWEvolution},
                          qwd_discr::AbstractDiscretizedQWModel,
                          params::Dict{Symbol},
                          marked::Vector{Symbol})
    check_qwdynamics(T, model(qwd_discr), parameters(params[:qwd_internal]), marked)
end

function expected_runtime(qws::QWSearch{<:AbstractDiscretizedQWModel},
                          qstate::QSearchState)
    true_time = real_runtime(model(qws), runtime(qstate)) + penalty(qws)
    expected_runtime(true_time, sum(state.probability))
end

function dynamics_internal(qwd::QWDynamics{<:AbstractDiscretizedQWModel})
    return qwd.parameters[:qwd_internal]
end

function parameters(discrqwmodel::QWDynamics{<:AbstractDiscretizedQWModel})
    parameters(dynamics_internal(discrqwmodel))
end

function marked(qwsearch_discr::QWSearch{<:AbstractDiscretizedQWModel})
    marked(dynamics_internal(discrqwmodel))
end
