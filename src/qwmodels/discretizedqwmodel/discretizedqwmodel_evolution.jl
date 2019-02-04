function initial_state(qws::QWSearch{<:AbstractDiscretizedQWModel})
    initial_state(dynamics_internal(qws))
end

function evolve(qwd::QWDynamics{<:AbstractDiscretizedQWModel}, state)
    evolve(dynamics_internal(qwd), state, granulation(model(qwd)))
end

function measure(qwd::QWDynamics{<:AbstractDiscretizedQWModel}, state)
    measure(dynamics_internal(qwd), state)
end

function measure(qwd::QWDynamics{<:AbstractDiscretizedQWModel}, state, vertices::Vector{Int})
    measure(dynamics_internal(qwd), state, vertices)
end
