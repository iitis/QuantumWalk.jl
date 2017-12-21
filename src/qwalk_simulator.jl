export
   walk,
   all_walk,
   all_measured_walk

"""
    walk
"""
function walk(qws::QWalkSimulator{T} where T<:ContQWalk,
              initstate::S where S,
              runtime::U where U<:Real)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   evolve(qws, initstate, runtime)
end

function walk(qws::QWalkSimulator{T} where T<:DiscrQWalk,
              initstate::S where S,
              runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   state = initstate
   for t=1:runtime
      state = evolve(qws, state)
   end

   state
end

"""
    all_walk
"""
function all_walk(qss::QWalkSimulator{T} where T<:DiscrQWalk,
                  initstate::S,
                  runtime::Int) where S
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   result = S[]([initstate])

   for t=1:runtime
      push!(result, evolve(qws, state))
   end

   result
end

"""
    all_measured_walk
"""
function all_measured_walk(qws::QWalkSimulator{T} where T<:DiscrQWalk,
                           initstate::S where S,
                           runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"
   
   result = zeros(Float64, (nv(graph(qss)), runtime+1)) # +1 to include 0

   state = initial_state(qws)
   result[:,1] = measure(qws, state)

   for t=1:runtime
      state = evolve(qws, state)
      result[:,t+1] = measure(qws, state) #evolution starts with t=0
   end

   result
end
