export
   execute,
   execute_single,
   execute_single_measured,
   execute_all,
   execute_all_measured

"""
    execute(qwd, initstate, runtime[, all=false, measure=false])

Run proper execution function depending on given keywords. `all` and `measure`
keywords defaults to `false`. In case of `all` being true, all intermidiate states
are returned. Note that for `all` equal to `true`, the model
specified by `qwd` needs to be disrete. For `measure` equal to true, measurement
distributions are returned.
"""
function execute(qwd::QWDynamics,
                 initstate,
                 runtime::Real;
                 all::Bool = false,
                 measure::Bool = false)
   if !all && !measure
      execute_single(qwd, initstate, runtime)
   elseif !all && measure
      execute_single_measured(qwd, initstate, runtime)
   elseif all && !measure
      execute_all(qwd, initstate, runtime)
   else
      execute_all_measured(qwd, initstate, runtime)
   end
end

"""
    execute_single(qwd, initstate, runtime)

Evolve `initstate` according to QWDynamics `qwd` for time `runtime`.
`runtime` needs to be nonnegative.
"""
function execute_single(qwd::QWDynamics{<:QWModelDiscr},
                        initstate,
                        runtime::Int)
   @assert runtime>=0 "Argument 'runtime' needs to be nonnegative"

   state = initstate
   for t=1:runtime
      state = evolve(qwd, state)
   end

   state
end,

function execute_single(qwd::QWDynamics{<:QWModelCont},
                        initstate,
                        runtime::Real)
   @assert runtime>=0 "Argument 'runtime' needs to be nonnegative"

   evolve(qwd, initstate, runtime)
end

"""
    execute_single_measured(qwd, initstate, runtime)

Evolve `initstate` acording to `qwd` for time `runtime` and measure
it in the end. `runtime` needs to be nonnegative.
"""
function execute_single_measured(qwd::QWDynamics,
                                 initstate,
                                 runtime::Real)
   measure(qwd, execute_single(qwd, initstate, runtime))
end


"""
    execute_all(qwd, initstate, runtime)

Returns list of all states including the `initstate` according to `qwd` for
times from 0 to `runtime`. `runtime` needs to be nonnegative.
"""
function execute_all(qwd::QWDynamics{<:QWModelDiscr},
                     initstate::S,
                     runtime::Int) where S
   @assert runtime>=0 "Argument 'runtime' needs to be nonnegative"

   result = Vector{S}([initstate])
   state = initstate
   for t=1:runtime
      state = evolve(qwd, state)
      push!(result, state)
   end

   result
end

"""
    execute_all_measured(qwd, initstate, runtime)

Evolve `initstate` acording to `qwd` for time `runtime`. Returns matrix of type
`Matrix{Float64}` for which `i`-th column is the probability distribution obtained
 from the measurement in (`i-1`)-th step. `runtime` needs to be nonnegative.
"""
function execute_all_measured(qwd::QWDynamics{<:QWModelDiscr},
                              initstate,
                              runtime::Int)
   @assert runtime>=0 "Argument 'runtime' needs to be nonnegative"

   result = zeros(Float64, (nv(graph(qwd)), runtime+1)) # +1 to include 0

   state = initstate
   result[:,1] = measure(qwd, state)
   for t=1:runtime
      state = evolve(qwd, state)
      result[:,t+1] = measure(qwd, state) #evolution starts with t=0
   end

   result
end
