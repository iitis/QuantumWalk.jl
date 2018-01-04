export
   walk,
   all_walk,
   all_measured_walk

"""
    walk(qws, initstate, runtime)

Evolve `initstate` acording to QWalkSimulator `qws` for time `runtime`.
`runtime` needs to be nonnegative. If `qws` is based on on `DiscrQWalk`, it
needs to be `Int`.

```@docs
julia> qws = QWalkSimulator(Szegedy(CompleteGraph(4)));

julia> state = spzeros(16); state[1] = state[2] = 1/sqrt(2.);

julia> walk(qws, state, 10)
16-element SparseVector{Float64,Int64} with 13 stored entries:
  [1 ]  =  0.707107
  [2 ]  =  0.6615
  [3 ]  =  -0.0114017
  [4 ]  =  -0.0114017
  [5 ]  =  -1.21431e-16
  [7 ]  =  -0.111417
  [8 ]  =  -0.111417
  [9 ]  =  0.13422
  [10]  =  -0.0114017
  [12]  =  0.0228034
  [13]  =  0.13422
  [14]  =  -0.0114017
  [15]  =  0.0228034
```
"""
function walk(qws::QWalkSimulator{<:ContQWalk}, initstate, runtime::Real)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   evolve(qws, initstate, runtime)
end

function walk(qws::QWalkSimulator{<:DiscrQWalk}, initstate, runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   state = initstate
   for t=1:runtime
      state = evolve(qws, state)
   end

   state
end

"""
    all_walk(qws, initstate, runtime)

Evolve `initstate` acording to QWalkSimulator `qws` for time `runtime`.
`runtime` needs to be nonnegative. If `qws` is based on on `DiscrQWalk`, it
needs to be `Int`.

```@docs
julia> qws = QWalkSimulator(Szegedy(CompleteGraph(4)));

julia> state = spzeros(16); state[1] = state[2] = 1/sqrt(2.);

julia> walk(qws, state, 10)
16-element SparseVector{Float64,Int64} with 13 stored entries:
  [1 ]  =  0.707107
  [2 ]  =  0.6615
  [3 ]  =  -0.0114017
  [4 ]  =  -0.0114017
  [5 ]  =  -1.21431e-16
  [7 ]  =  -0.111417
  [8 ]  =  -0.111417
  [9 ]  =  0.13422
  [10]  =  -0.0114017
  [12]  =  0.0228034
  [13]  =  0.13422
  [14]  =  -0.0114017
  [15]  =  0.0228034
```
"""
function all_walk(qss::QWalkSimulator{<:DiscrQWalk},
                  initstate::S,
                  runtime::Int) where S
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   result = S[]([initstate])

   for t=1:runtime
      state = walk(qws, state, 1)
      push!(result, state)
   end

   result
end

"""
    all_measured_walk
"""
function all_measured_walk(qws::QWalkSimulator{<:DiscrQWalk},
                           initstate,
                           runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   result = zeros(Float64, (nv(graph(qss)), runtime+1)) # +1 to include 0

   state = initial_state(qws)
   result[:,1] = measure(qws, state)

   for t=1:runtime
      state = walk(qws, state, 1)
      result[:,t+1] = measure(qws, state) #evolution starts with t=0
   end

   result
end
