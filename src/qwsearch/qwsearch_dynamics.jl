export
   execute,
   execute_single,
   execute_single_measured,
   execute_all,
   execute_all_measured


function execute(qss::QWSearch,
                 runtime::Real;
                 all::Bool = false,
                 measure::Bool = false)
   if !all && !measure
     execute_single(qss, runtime)
   elseif !all && measure
     execute_single_measured(qss, runtime)
   elseif all && !measure
     execute_all(qss, runtime)
   else
     execute_all_measured(qss, runtime)
   end
end

"""

"""
function execute_single(qss::QWSearch{<:QWModelDiscr},
                        initstate,
                        runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   state = initstate
   for t=1:runtime
      state = evolve(qss, state)
   end

   QSearchState(qss, state, runtime)
end

function execute_single(qss::QWSearch{<:QWModelCont},
                        initstate,
                        runtime::Real)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   QSearchState(qss, evolve(qss, initstate, runtime), runtime)
end

function execute_single(qss::QWSearch, runtime::Real)
   execute_single(qss, initial_state(qss), runtime)
end

"""

"""
function execute_single_measured(qss::QWSearch, runtime::Real)
   execute_single_measured(qss, initial_state(qss), runtime)
end


"""

"""
function execute_all(qss::QWSearch{<:QWModelDiscr},
                     initstate::S,
                     runtime::Int) where S
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   result = Vector{QSearchState{S,Int}}([QSearchState(qss, initstate, 0)])
   state = initstate
   for t=1:runtime
      state = evolve(qss, state)
      push!(result, QSearchState(qss, state, t))
   end

   result
end

function execute_all(qss::QWSearch{<:QWModelDiscr}, runtime::Int)
   execute_all(qss, initial_state(qss), runtime)
end
"""

"""
function execute_all_measured(qss::QWSearch, runtime::Real)
   execute_all_measured(qss, initial_state(qss), runtime)
end
