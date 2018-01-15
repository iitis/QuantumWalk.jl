export
   execute,
   execute_single,
   execute_single_measured,
   execute_all,
   execute_all_measured


"""
    execute(qwd, initstate, runtime[, all, measure])

Run proper execution function depending on given keywords. `all` and `measure` keywords
defaults to `false`. For detailed description please see documentation of
corresponding function. Note that for `all` equal to `true` model in `qwd` needs
to be disrete.
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

Evolve `initstate` acording to QWDynamics `qwd` for time `runtime`.
`runtime` needs to be nonnegative. If `qwd` is based on on `QWModelDiscr`, `runtime`
needs to be `Int`.

```jldoctest
julia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));

julia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);

julia> execute_single(qwe, initstate, 10)
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
function execute_single(qwd::QWDynamics{<:QWModelDiscr},
                        initstate,
                        runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   state = initstate
   for t=1:runtime
      state = evolve(qwd, state)
   end

   state
end

function execute_single(qwd::QWDynamics{<:QWModelCont},
                        initstate,
                        runtime::Real)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   evolve(qwd, initstate, runtime)
end

"""
    execute_single_measured(qwd, initstate, runtime)

Evolve `initstate` acording to QWDynamics `qwd` for time `runtime`.
`runtime` needs to be nonnegative, and measure it in the end.
If `qwd` is based on on `QWModelDiscr`, `runtime` needs to be `Int`.

```jldoctest
julia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));

julia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);

julia> execute_single_measured(qwe, initstate, 10)
4-element Array{Float64,1}:
 0.937842
 0.0248275
 0.0186651
 0.0186651

```
"""
function execute_single_measured(qwd::QWDynamics,
                                 initstate,
                                 runtime::Real)
   measure(qwd, execute_single(qwd, initstate, runtime))
end


"""
    execute_all(qwd::QWDynamics{<:QWModelDiscr}, initstate, runtime)

Evolve `initstate` acording to QWDynamics `qwd` for time `runtime`.
`runtime` needs to be nonnegative. Quantum walk model needs to be discrete.
Returns list of all states including `initstate` and last state.

```jldoctest
julia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));

julia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);

julia> execute_all(qwe, initstate, 2)
3-element Array{SparseVector{Float64,Int64},1}:
   [1 ]  =  0.707107
  [2 ]  =  0.707107
   [1 ]  =  0.707107
  [2 ]  =  0.0785674
  [3 ]  =  -0.157135
  [4 ]  =  -0.157135
  [7 ]  =  0.31427
  [8 ]  =  0.31427
  [10]  =  -0.157135
  [12]  =  0.31427
  [14]  =  -0.157135
  [15]  =  0.31427
   [1 ]  =  0.707107
  [2 ]  =  0.427756
  [3 ]  =  -0.0698377
  [4 ]  =  -0.0698377
  [5 ]  =  -5.55112e-17
  [7 ]  =  -0.174594
  [8 ]  =  -0.174594
  [9 ]  =  0.31427
  [10]  =  -0.0698377
  [12]  =  0.139675
  [13]  =  0.31427
  [14]  =  -0.0698377
  [15]  =  0.139675

```
"""
function execute_all(qwd::QWDynamics{<:QWModelDiscr},
                     initstate::S,
                     runtime::Int) where S
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   result = Vector{S}([initstate])
   state = initstate
   for t=1:runtime
      state = evolve(qwd, state)
      push!(result, state)
   end

   result
end

"""
    execute_all_measured(qwd::QWDynamics{<:QWModelDiscr}, initstate, runtime)

Evolve `initstate` acording to QWDynamics `qwd` for time `runtime`.
`runtime` needs to be nonnegative. Quantum walk model needs to be discrete.
As a result return matrix of type `Matrix{Float64}` for which `i`-th column  is
measurement probability distribution in `i-1`-th step.

```jldoctest
julia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));

julia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);

julia> execute_all_measured(qwe, initstate, 2)
4×3 Array{Float64,2}:
 1.0  0.555556  0.69273
 0.0  0.197531  0.0609663
 0.0  0.123457  0.123152
 0.0  0.123457  0.123152

```
"""
function execute_all_measured(qwd::QWDynamics{<:QWModelDiscr},
                              initstate,
                              runtime::Int)
   @assert runtime>=0 "Parameter 'runtime' needs to be nonnegative"

   result = zeros(Float64, (nv(graph(qwd)), runtime+1)) # +1 to include 0

   state = initstate
   result[:,1] = measure(qwd, state)
   for t=1:runtime
      state = evolve(qwd, state)
      result[:,t+1] = measure(qwd, state) #evolution starts with t=0
   end

   result
end
