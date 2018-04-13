var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Welcome-to-QuantumWalk.jl-1",
    "page": "Home",
    "title": "Welcome to QuantumWalk.jl",
    "category": "section",
    "text": "QuantumWalk.jl is a package providing general functionalities and implementations of quantum walks. The package uses the Julia\'s type hierarchy to produce general functions working on at least large collection of quantum walk models."
},

{
    "location": "index.html#Why?-1",
    "page": "Home",
    "title": "Why?",
    "category": "section",
    "text": "Since the very first paper defining quantum walk, plenty of quantum walk models were proposed. This includes continuous-time quantum walk, Szegedy quantum walk, coined quantum walk, stochastic quantum walk or flip-flop quantum walk, to name a few. Most of the models have the same applications as for example spatial search or transport. Furthermore models are compared by general properties such as localization, propagation or trapping.The purpose of the package is not to provide an implementations of all models, as this is simply impossible due to quantum walk theory progress. Our aim is to provide cross functionality: implementing properly single model allows using already implemented dynamics such as spatial search or pure walk evolution. Contrary, if we came out with some interesting general quantum walk property, we can use the package for analysing already existing models."
},

{
    "location": "index.html#How?-1",
    "page": "Home",
    "title": "How?",
    "category": "section",
    "text": "The package implements two independent type hierarchies: one for quantum walk model, one for quantum dynamics. If possible, the quantum dynamics is defined iff proper functions for quantum walk models are defined. For example if we provide evolve, measure and check_qwdynamics methods we can use the model for simulating pure walk evolution. Similarly we need initial_state, evolve, measure and check_qwdynamics for quantum spatial search dynamics.Currently defined quantum walk models are presented in section Exemplary models, while exemplary quantum dynamics are presented in Exemplary models."
},

{
    "location": "index.html#Can-I-contribute?-1",
    "page": "Home",
    "title": "Can I contribute?",
    "category": "section",
    "text": "Yes, You can! As there are simply to many models and quantum dynamics we cannot deal with such on our own. The details concerning contribution can be found in Contributing section."
},

{
    "location": "type_hierarchy.html#",
    "page": "Type hierarchy",
    "title": "Type hierarchy",
    "category": "page",
    "text": "DocTestSetup = quote\n   using QuantumWalk, LightGraphs\nend"
},

{
    "location": "type_hierarchy.html#Type-hierarchy-1",
    "page": "Type hierarchy",
    "title": "Type hierarchy",
    "category": "section",
    "text": "The package consists of two main type hierarchies: quantum walk model hierarchy, which is simply a description of the quantum walk model, and quantum walk dynamics, which are used for quantum walk analysis or simulation. The first one should in general be small, and should consist only of general parameters used in most of the models. Second one should possess all information needed for efficient simulation/analysis. For example CTQW model should consist of graph, on which the evolution is made and label which implies if adjacency or Laplacian matrix is used. Contrary QWEvolution{CTQW} should consist of Hamiltonian used for evolution."
},

{
    "location": "type_hierarchy.html#Quantum-walk-models-hierarchy-1",
    "page": "Type hierarchy",
    "title": "Quantum walk models hierarchy",
    "category": "section",
    "text": "The main supertype is QWModel. As typically discrete and continuous evolution are simulated and analysed using different techniques, QWModelCont and QWModelDiscr are its direct subtypes. Furthermore every model have its direct abstract supertype, which is at least similar in the sense of implemented function to the supertype.Any instance of quantum walk model consists of graph on which evolution is made. Such graph can be accessed via graph function. Hence an typical definition of quantum walk model type takes the fromstruct Model <: AbstractModel\n   graph::Graph\n   ...\n   function Model(graph::Graph, ...)\n      ...\n      new(graph, ...)\n   end\nendAt the moment CTQW and Szegedy walks are implemented. Note that arbitrary quantum walk model should consist of measure, evolve and check_qwdynamics for basic pure walk simulation."
},

{
    "location": "type_hierarchy.html#Quantum-dynamics-hierarchy-1",
    "page": "Type hierarchy",
    "title": "Quantum dynamics hierarchy",
    "category": "section",
    "text": "The main supertype is QWDynamics. As the algorithms and analysis usually differs strongly, subtypes of QWDynamics should be mostly a composite types.Any QWDynamics should consist of at least two parameters: model, which is a quantum walk model, and parameters, which is a dictionary consisting of values needed for model. Elements are accessible via function with the same name. In order to check correctness, check_qwdynamics should always be executed in the constructor. Typical quantum walk dynamics are defined as follows.struct Dynamics{T} <: QWDynamics{T}\n  model::T\n  parameters::Dict{Symbol}\n  ...\n\n  function Dynamics(model::T, parameters::Dict{Symbol}, ...) where T<:QWModel\n     ...\n     check_qwdynamics(::Dynamics, model, parameters, ...)\n     ...\n     new(model, parameters, ...)\n  end\nendAt the moment QWEvolution for pure walk evolution and QWSearch for quantum spatial search are implemented. All dynamics provides execute functionality, together with their its variation. For details see section below."
},

{
    "location": "type_hierarchy.html#Documentation-1",
    "page": "Type hierarchy",
    "title": "Documentation",
    "category": "section",
    "text": "Following functions are connected to the presented topic:Order = [:type, :function]\nModules = [QuantumWalk]\nPages   = [\"quantum_walk.md\"]"
},

{
    "location": "type_hierarchy.html#QuantumWalk.QWDynamics",
    "page": "Type hierarchy",
    "title": "QuantumWalk.QWDynamics",
    "category": "type",
    "text": "QWDynamics{T<:QWModel}\n\nAbstract supertype of all dynamics on quantum walk models.\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.QWModel",
    "page": "Type hierarchy",
    "title": "QuantumWalk.QWModel",
    "category": "type",
    "text": "QWModel\n\nAbstract supertype of all quantum walk models.\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.QWModelCont",
    "page": "Type hierarchy",
    "title": "QuantumWalk.QWModelCont",
    "category": "type",
    "text": "QWModelCont\n\nAbstract supertype of all continuous quantum walk models.\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.QWModelDiscr",
    "page": "Type hierarchy",
    "title": "QuantumWalk.QWModelDiscr",
    "category": "type",
    "text": "QWModelDiscr\n\nAbstract supertype of all discrete quantum walk models.\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.graph-Tuple{QuantumWalk.QWModel}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.graph",
    "category": "method",
    "text": "graph(model)\n\nReturns graph element of model.\n\njulia> ctqw = CTQW(CompleteGraph(4))\nQuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency)\n\njulia> graph(ctqw)\n{4, 6} undirected simple Int64 graph\n\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.graph-Tuple{QuantumWalk.QWDynamics}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.graph",
    "category": "method",
    "text": "graph(qwd)\n\nReturns graph element of model from qwd. Equivalent to graph(model(qwd)).\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> graph(qss)\n{4, 6} undirected simple Int64 graph\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.model-Tuple{QuantumWalk.QWDynamics}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.model",
    "category": "method",
    "text": "model(qwd)\n\nReturns model element of qwd.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> model(qss)\nQuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency)\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.parameters-Tuple{QuantumWalk.QWDynamics}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.parameters",
    "category": "method",
    "text": "parameters(qwd)\n\nReturns parameters element of qwd.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> parameters(qss)\nDict{Symbol,Any} with 1 entry:\n  :hamiltonian => …\n\n\n\n\n"
},

{
    "location": "type_hierarchy.html#Full-docs-1",
    "page": "Type hierarchy",
    "title": "Full docs",
    "category": "section",
    "text": "QWDynamics\nQWModel\nQWModelCont\nQWModelDiscr\ngraph(::QWModel)\ngraph(::QWDynamics)\nmodel(::QWDynamics)\nparameters(::QWDynamics)"
},

{
    "location": "quantum_walk.html#",
    "page": "Quantum walk evolution",
    "title": "Quantum walk evolution",
    "category": "page",
    "text": "DocTestSetup = quote\n   using QuantumWalk, LightGraphs\nend"
},

{
    "location": "quantum_walk.html#Quantum-evolution-1",
    "page": "Quantum walk evolution",
    "title": "Quantum evolution",
    "category": "section",
    "text": "The simplest quantum walk evolution. It simply takes the model and initial state from the user, simulate an evolution and outputs the state or the probability distribution of measured state.The dynamics requires evolve, measure and check_qwdynamics functions. It provides execute, execute_single, execute_single_measured, execute_all and execute_all_measured functions. Depending on the name it outputs single state or all states, measured or not measured. The execute combines the last four functions. In the case of type-stability requirement, we recommend to use the last four functions. execute_all and execute_all_measured are provided only for discrete quantum walk models.Following functions are connected to the dynamics:Order = [:type, :function]\nModules = [QuantumWalk]\nPages   = [\"quantum_walk.md\"]"
},

{
    "location": "quantum_walk.html#Example-1",
    "page": "Quantum walk evolution",
    "title": "Example",
    "category": "section",
    "text": "julia> using LightGraphs, QuantumWalk\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> state = rand(16); state = sparse(state/norm(state));\n\njulia> execute_single(qwe, state, 4)\n16-element SparseVector{Float64,Int64} with 16 stored entries:\n  [1 ]  =  0.37243\n  [2 ]  =  0.402212\n  [3 ]  =  0.356914\n  [4 ]  =  0.0384893\n  [5 ]  =  0.230443\n  [6 ]  =  0.0373444\n  [7 ]  =  0.12092\n  [8 ]  =  0.285178\n  [9 ]  =  0.151519\n  [10]  =  0.258755\n  [11]  =  0.30374\n  [12]  =  0.375624\n  [13]  =  0.169741\n  [14]  =  -0.0403198\n  [15]  =  0.255573\n  [16]  =  0.0344363\n\njulia> execute_all_measured(qwe, state, 4)\n4×5 Array{Float64,2}:\n 0.273249  0.455568  0.308632  0.339199  0.429348\n 0.20334   0.165956  0.188335  0.188466  0.150447\n 0.244393  0.213254  0.378161  0.171268  0.323264\n 0.279018  0.165221  0.124872  0.301066  0.0969412\n\njulia> execute(qwe, state, 4, )\nexecute(qwd::QuantumWalk.QWDynamics, initstate, runtime::Real; all, measure) in QuantumWalk at /home/adam/.julia/v0.6/QuantumWalk/src/dynamics.jl:23\njulia> execute(qwe, state, 4, measure=true, all=true)\n4×5 Array{Float64,2}:\n 0.273249  0.455568  0.308632  0.339199  0.429348\n 0.20334   0.165956  0.188335  0.188466  0.150447\n 0.244393  0.213254  0.378161  0.171268  0.323264\n 0.279018  0.165221  0.124872  0.301066  0.0969412"
},

{
    "location": "quantum_walk.html#Adjusting-model-to-QWEvolution-1",
    "page": "Quantum walk evolution",
    "title": "Adjusting model to QWEvolution",
    "category": "section",
    "text": "The QWEvolution requires an implementation of evolve, measure and check_qwdynamics. Instead of implementing purely quantum walk, we will implement simple random walk, which still fits our considerations. Note that we creates an additional AbstractStochastic supertype, in case someone would prefer to make different stochastic evolution (for example change the stochastic matrix). Note we skipped some assertion checking for readability. Furthermore note we have defined two versions of measure: in most cases measuring only part of vertices are faster than making full measurement.abstract type AbstractStochastic <: QWModelDiscr end\n\nstruct UniformStochastic{G<:SimpleGraph} <: AbstractStochastic\n  graph::G\nend\n\nUniformScaling(digraph::G) where G= UniformStochastic{G}(digraph)\n\nfunction check_qwdynamics(::Type{QWEvolution},\n                          abs_stoch::UniformStochastic,\n                          parameters::Dict{Symbol,Any})\n  @assert :stochastic ∈ keys(parameters) \"parameters needs to have key stochastic\"\n  n = nv(graph(abs_stoch))\n  @assert isa(parameters[:stochastic], SparseMatrixCSC{<:Real}) \"value for :stochastic needs to be sparse matrix with real numbers\"\n  @assert size(parameters[:stochastic], 1) == size(parameters[:stochastic], 2) \"Stochastic matrix needs to be square stochastic matrix\"\n  @assert mapslices(sum, parameters[:stochastic], 1)[1,:] ≈ ones(n) \"Stochastic matrix needs to be square stochastic matrix of order graph\"\nend\n\nfunction stochastic_matrix(g::SimpleGraph)\n  a = adjacency_matrix(g)\n  a*spdiagm(mapslices(x->1/sum(x), a, 1)[1,:])\nend\n\nfunction QWEvolution(stoch::AbstractStochastic)\n   parameters = Dict{Symbol,Any}(:stochastic => stochastic_matrix(graph(stoch)))\n   QWEvolution(stoch, parameters)\nend\n\nfunction stochastic_evolution(s::SparseMatrixCSC{T}, v::Vector{T}) where T<:Real\n  s*v\nend\n\nfunction evolve(qss::QWDynamics{<:AbstractStochastic}, state)\n  stochastic_evolution(parameters(qss)[:stochastic], state)\nend\n\nfunction measure(::QWDynamics{<:AbstractStochastic}, state::Vector{<:Real})\n   return state\nend\n\nfunction measure(::QWDynamics{<:AbstractStochastic},\n                 state::Vector{<:Real},\n                 vertices::Vector{Int})\n   return state[vertices]\nendThanks to the definition above we can make a pure walk evolution.dynamic = QWEvolution(UniformStochastic(smallgraph(:bull)))\n\nprintln(execute_single(dynamic, fill(1./5, 5), 5))\n# [0.186831, 0.313169, 0.313169, 0.0934156, 0.0934156]Note that continuous quantum walks requires time argument in evolution function."
},

{
    "location": "quantum_walk.html#QuantumWalk.QWEvolution",
    "page": "Quantum walk evolution",
    "title": "QuantumWalk.QWEvolution",
    "category": "type",
    "text": "QWEvolution(model, parameters)\n\nType describing standard quantum walk evolution. Needs implementation of\n\nevolve(::QWEvolution{<:QWModelDiscr}, state) or evolve(::QWEvolution{<:QWModelCont}, state, time::Real)\nmeasure(::QWEvolution, state)\ncheck_qwdynamics(::QWModelDiscr, parameters::Dict{Symbol})\nproper constructors.\n\nOffers functions\n\nexecute\nexecute_single\nexecute_single_measured\nexecute_all\nexecute_all_measured\n\n\n\n"
},

{
    "location": "quantum_walk.html#QuantumWalk.check_qwdynamics-Tuple{Any}",
    "page": "Quantum walk evolution",
    "title": "QuantumWalk.check_qwdynamics",
    "category": "method",
    "text": "check_qwdynamics(dynamictype, model, ..., parameters)\n\nChecks whetver combination of the arguments creates valid quantum walk dynamics. The behaviour strongly depends on arguments.\n\n\n\n"
},

{
    "location": "quantum_walk.html#QuantumWalk.evolve-Tuple{Any}",
    "page": "Quantum walk evolution",
    "title": "QuantumWalk.evolve",
    "category": "method",
    "text": "evolve(qwevolution{<:QWModelDiscr}, state)\nevolve(qwevolution{<:QWModelCont}, state, time)\n\nEvolve state according to qwevolution. time should be provided if model is continuous, otherwise one-step evolution should be performed. Type returned should be the same as type of state. The behaviour strongly depends on arguments.\n\n\n\n"
},

{
    "location": "quantum_walk.html#QuantumWalk.execute-Tuple{QuantumWalk.QWDynamics,Any,Real}",
    "page": "Quantum walk evolution",
    "title": "QuantumWalk.execute",
    "category": "method",
    "text": "execute(qwd, initstate, runtime[, all, measure])\n\nRun proper execution function depending on given keywords. all and measure keywords defaults to false. For detailed description please see documentation of the corresponding function. Note that for all equal to true, the model specified by qwd needs to be disrete.\n\n\n\n"
},

{
    "location": "quantum_walk.html#QuantumWalk.execute_all-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Quantum walk evolution",
    "title": "QuantumWalk.execute_all",
    "category": "method",
    "text": "execute_all(qwd::QWDynamics{<:QWModelDiscr}, initstate, runtime)\n\nEvolve initstate acording to QWDynamics qwd for time runtime. Parameter runtime needs to be nonnegative and wqantum walk model needs to be discrete. Returns list of all states including the initstate and the final state.\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);\n\njulia> execute_all(qwe, initstate, 2)\n3-element Array{SparseVector{Float64,Int64},1}:\n   [1 ]  =  0.707107\n  [2 ]  =  0.707107\n   [1 ]  =  0.707107\n  [2 ]  =  0.0785674\n  [3 ]  =  -0.157135\n  [4 ]  =  -0.157135\n  [7 ]  =  0.31427\n  [8 ]  =  0.31427\n  [10]  =  -0.157135\n  [12]  =  0.31427\n  [14]  =  -0.157135\n  [15]  =  0.31427\n   [1 ]  =  0.707107\n  [2 ]  =  0.427756\n  [3 ]  =  -0.0698377\n  [4 ]  =  -0.0698377\n  [5 ]  =  -5.55112e-17\n  [7 ]  =  -0.174594\n  [8 ]  =  -0.174594\n  [9 ]  =  0.31427\n  [10]  =  -0.0698377\n  [12]  =  0.139675\n  [13]  =  0.31427\n  [14]  =  -0.0698377\n  [15]  =  0.139675\n\n\n\n\n"
},

{
    "location": "quantum_walk.html#QuantumWalk.execute_all_measured-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Quantum walk evolution",
    "title": "QuantumWalk.execute_all_measured",
    "category": "method",
    "text": "execute_all_measured(qwd::QWDynamics{<:QWModelDiscr}, initstate, runtime)\n\nEvolve initstate acording to QWDynamics qwd for time runtime. Parameter runtime needs to be nonnegative and quantum walk model needs to be discrete. Returns matrix of type Matrix{Float64} for which i-th column  is the probability distribution obtained from the measurement in i-1-th step.\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);\n\njulia> execute_all_measured(qwe, initstate, 2)\n4×3 Array{Float64,2}:\n 1.0  0.555556  0.69273\n 0.0  0.197531  0.0609663\n 0.0  0.123457  0.123152\n 0.0  0.123457  0.123152\n\n\n\n\n"
},

{
    "location": "quantum_walk.html#QuantumWalk.execute_single-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Quantum walk evolution",
    "title": "QuantumWalk.execute_single",
    "category": "method",
    "text": "execute_single(qwd, initstate, runtime)\n\nEvolve initstate acording to QWDynamics qwd for time runtime. Parameter runtime needs to be nonnegative. If qwd subtype of QWModelDiscr, runtime needs to be of type Int.\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);\n\njulia> execute_single(qwe, initstate, 10)\n16-element SparseVector{Float64,Int64} with 13 stored entries:\n  [1 ]  =  0.707107\n  [2 ]  =  0.6615\n  [3 ]  =  -0.0114017\n  [4 ]  =  -0.0114017\n  [5 ]  =  -1.21431e-16\n  [7 ]  =  -0.111417\n  [8 ]  =  -0.111417\n  [9 ]  =  0.13422\n  [10]  =  -0.0114017\n  [12]  =  0.0228034\n  [13]  =  0.13422\n  [14]  =  -0.0114017\n  [15]  =  0.0228034\n\n\n\n"
},

{
    "location": "quantum_walk.html#QuantumWalk.execute_single_measured-Tuple{QuantumWalk.QWDynamics,Any,Real}",
    "page": "Quantum walk evolution",
    "title": "QuantumWalk.execute_single_measured",
    "category": "method",
    "text": "execute_single_measured(qwd, initstate, runtime)\n\nEvolve initstate acording to QWDynamics qwd for time runtime and measure it in the end. Parameter runtime needs to be nonnegative. If qwd is subtype of QWModelDiscr, runtime needs to be Int.\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);\n\njulia> execute_single_measured(qwe, initstate, 10)\n4-element Array{Float64,1}:\n 0.937842\n 0.0248275\n 0.0186651\n 0.0186651\n\n\n\n\n"
},

{
    "location": "quantum_walk.html#QuantumWalk.measure-Tuple{Any}",
    "page": "Quantum walk evolution",
    "title": "QuantumWalk.measure",
    "category": "method",
    "text": "measure(qwevolution, state[, vertices])\n\nMeasure state according to model from quantum walk evolution qwevolution. If vertices is provided, probabilities of given vertices should be provided. Otherwise full probability distribution should be provided. Output should be always of type Array{Float64}. The behaviour strongly depends on arguments\n\n\n\n"
},

{
    "location": "quantum_walk.html#Full-docs-1",
    "page": "Quantum walk evolution",
    "title": "Full docs",
    "category": "section",
    "text": "QWEvolution\ncheck_qwdynamics(::Any)\nevolve(::Any)\nexecute(::QWDynamics, ::Any, ::Real)\nexecute_all(qwd::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)\nexecute_all_measured(qwd::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)\nexecute_single(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)\nexecute_single_measured(::QWDynamics, ::Any, ::Real)\nmeasure(::Any)"
},

{
    "location": "quantum_search.html#",
    "page": "Quantum search",
    "title": "Quantum search",
    "category": "page",
    "text": "DocTestSetup = quote\n   using QuantumWalk, LightGraphs\nend"
},

{
    "location": "quantum_search.html#Quantum-Search-1",
    "page": "Quantum search",
    "title": "Quantum Search",
    "category": "section",
    "text": "Quantum spatial search is an algorithm, which starts at some initial state (which  depends on the graph structure), and runs for some time in order to cumulate  amplitude at marked vertex. The algorithm is known to outperform classical search.The dynamics requires evolve, measure, initial_state and check_qwdynamics functions. It provides execute, execute_single, execute_single_measured, execute_all and execute_all_measured functions - the description can be found in Quantum walk evolution section. The only difference is that QWSearch uses the state provided by initial_state function, unless other is provided. Furthermore the function provides marked, penalty and maximize_quantum_search. While the first two simple provides the parameters typical to QWSearch, the last one searches for optimal measure time. The maximization depends on the model (if it is continuous or discrete). While for discrete evolution obtaining reasonable result is guaranteed, it is not the case for the continuous one, as the optimization suffers for locating at local extrema.The penalty is an additional time added in optimization. Note, that if we optimize  time/success_probability(time) function, the optimum is always at time 0. This would imply that algorithm achieves full efficiency if it is instantly measured. This is misleading, as the time for constructing initial state and for measurement is ignored.  Hence we need to include (usually small) additional time in penalty in order to  get useful result. Note the  time/success_probability(time) is at called  expected_runtime and can be obtained by expected_runtime function.Some function as a result outputs not QSearchState instead of the original state.  The struct consists of the original state, the runtime and the probability of measuring  each marked vertex. Those elements can be extracted by state, runtime and probability functions.Following functions are connected to the quantum search:Order = [:type, :function]\nModules = [QuantumWalk]\nPages   = [\"quantum_search.md\"]"
},

{
    "location": "quantum_search.html#Example-1",
    "page": "Quantum search",
    "title": "Example",
    "category": "section",
    "text": "using QuantumWalk, LightGraphs\n\nn = 100\npenalty_szegedy = log(n)\nqsearch = QWSearch(Szegedy(CompleteGraph(n)), [1], penalty_szegedy)\n\nruntime(maximize_quantum_search(qsearch))-penalty_szegedy\n# 5.0\n\nprobability(maximize_quantum_search(qsearch))\n# [0.569689]\n\nexecute_single_measured(qsearch, ceil(Int, pi*sqrt(100)/2))\n#100-element Array{Float64,1}:\n# 0.428475  \n# 0.00577298\n# 0.00577298\n# 0.00577298\n# 0.00577298\n# 0.00577298\n  ⋮         \n# 0.00577298\n# 0.00577298\n# 0.00577298\n# 0.00577298\n# 0.00577298"
},

{
    "location": "quantum_search.html#Adjusting-model-to-QWSearch-1",
    "page": "Quantum search",
    "title": "Adjusting model to QWSearch",
    "category": "section",
    "text": "Here we consider the example from the Quantum walk evolution section. We can consider random walk search as follows: at given step we check if we are at the marked vertex. If not, we continue evolution. Hence we need to cumulate the success probability at marked vertices. We can propose following implementation (including the functions from mentioned section).##\nfunction check_qwdynamics(::Type{QWSearch},\n                          abs_stoch::UniformStochastic,\n                          ::Array{Int},\n                          parameters::Dict{Symbol,Any})\n  @assert :stochastic ∈ keys(parameters) \"parameters needs to have key stochastic\"\n  n = nv(graph(abs_stoch))\n  @assert isa(parameters[:stochastic], SparseMatrixCSC{<:Real}) \"value for :stochastic needs to be sparse matrix with real numbers\"\n  @assert size(parameters[:stochastic], 1) == size(parameters[:stochastic], 2) \"Stochastic matrix needs to be square stochastic matrix\"\n  @assert mapslices(sum, parameters[:stochastic], 1)[1,:] ≈ ones(n) \"Stochastic matrix needs to be square stochastic matrix of order graph\"\nend\n\nfunction QWSearch(stoch::AbstractStochastic,\n                  marked::Array{Int},\n                  penalty::Real = 0.)\n   parameters = Dict{Symbol,Any}(:stochastic => stochastic_matrix(graph(stoch)))\n\n   QWSearch(stoch, marked, parameters, penalty)\nend\n\nfunction initial_state(qss::QWSearch{<:AbstractStochastic})\n  n = nv(graph(qss))\n  fill(1./n, n)\nend\n\nfunction evolve(qss::QWSearch{<:AbstractStochastic}, state::Vector{<:Real})\n  old_probability = measure(qss, state, marked(qss))\n  state[marked(qss)] = zero(marked(qss))\n  state = stochastic_evolution(parameters(qss)[:stochastic], state)\n  state[marked(qss)] += old_probability\n  state\nendNote that for example measure function does not change. Below we provide an evolution simulation example.dynamic = QWSearch(UniformStochastic(CompleteGraph(100)), [1])\n\nmeasure(dynamic, execute_single(dynamic, 0), [1])\n# [0.01]\n\nmeasure(dynamic, execute_single(dynamic, 40), [1])\n# [0.340416]\n\nmeasure(dynamic, execute_single(dynamic, 1000), [1])\n# [0.999961]"
},

{
    "location": "quantum_search.html#QuantumWalk.QWSearch",
    "page": "Quantum search",
    "title": "QuantumWalk.QWSearch",
    "category": "type",
    "text": "QWSearch(model, marked, parameters, penalty)\n\nSimulates quantum search on model with marked vertices and additional parameters. penalty represents the cost of initial state creation and measurement, which should be included for better optimization, see documentation of maximizing_function.\n\nNeeds implementation of\n\ninitial_state(::QWEvolution)\nevolve(::QWEvolution{<:QWModelDiscr}, state) or evolve(::QWEvolution{<:QWModelCont}, state, time::Real)\nmeasure(::QWEvolution, state)\ncheck_qwdynamics(::QWModelDiscr, parameters::Dict{Symbol})\nproper constructors.\n\nOffers functions\n\nexecute\nexecute_single\nexecute_single_measured\nexecute_all\nexecute_all_measured\nmaximize_quantum_search\nexpected_runtime\n\nand type QSearchState.\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.marked-Tuple{QuantumWalk.QWSearch}",
    "page": "Quantum search",
    "title": "QuantumWalk.marked",
    "category": "method",
    "text": "marked(qss)\n\nReturns marked element of qss.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> marked(qss)\n1-element Array{Int64,1}:\n 1\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.penalty-Tuple{QuantumWalk.QWSearch}",
    "page": "Quantum search",
    "title": "QuantumWalk.penalty",
    "category": "method",
    "text": "penalty(qss)\n\nReturns penalty element of qss.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> penalty(qss)\n0.0\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.check_qwdynamics-Tuple{QuantumWalk.QWSearch,Array{Int64,1},Dict{Symbol,V} where V}",
    "page": "Quantum search",
    "title": "QuantumWalk.check_qwdynamics",
    "category": "method",
    "text": "check_qwdynamics(model, marked, parameters)\n\nChecks whetver combination of model, marked and parameters creates valid quantum search evolution. Note that whetver list of vertices marked are a subset of vertices of graph from model is checked seperately in QWSearch constructor.\n\nDetails concerning implementing check_qwdynamics for own models can be found in GitHub pages.\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute-Tuple{QuantumWalk.QWSearch,Real}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute",
    "category": "method",
    "text": "execute(qss,[ initstate,] runtime[, all, measure])\n\nRun proper execution  of quantum spatial search depending on given keywords. The initial state is generated by initial_state(qss) function if not provided. all and measure keywords defaults to false. For detailed description please see documentation of corresponding function. Note that for all equal to true model in qss needs to be disrete.\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_single-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_single",
    "category": "method",
    "text": "execute_single(qss,[ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. The initial state is generated by initial_state(qss) function if not provided. runtime needs to be nonnegative. If qss is based on on QWModelDiscr, runtime needs to be Int. QSearchState{S}, where S is the state type, is returned.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_single(qss, 4)\nQuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.438623\n  [3 ]  =  0.438623\n  [4 ]  =  0.438623\n  [5 ]  =  0.104937\n  [7 ]  =  0.254884\n  [8 ]  =  0.254884\n  [9 ]  =  0.104937\n  [10]  =  0.254884\n  [12]  =  0.254884\n  [13]  =  0.104937\n  [14]  =  0.254884\n  [15]  =  0.254884, [0.577169], 4)\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_single-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.QWModelCont,Any,Real}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_single",
    "category": "method",
    "text": "execute_single(qss,[ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. The initial state is generated by initial_state(qss) function if not provided. runtime needs to be nonnegative. If qss is based on on QWModelDiscr, runtime needs to be Int. QSearchState{S}, where S is the state type, is returned.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_single(qss, 4)\nQuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.438623\n  [3 ]  =  0.438623\n  [4 ]  =  0.438623\n  [5 ]  =  0.104937\n  [7 ]  =  0.254884\n  [8 ]  =  0.254884\n  [9 ]  =  0.104937\n  [10]  =  0.254884\n  [12]  =  0.254884\n  [13]  =  0.104937\n  [14]  =  0.254884\n  [15]  =  0.254884, [0.577169], 4)\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_single-Tuple{QuantumWalk.QWSearch,Real}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_single",
    "category": "method",
    "text": "execute_single(qss,[ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. The initial state is generated by initial_state(qss) function if not provided. runtime needs to be nonnegative. If qss is based on on QWModelDiscr, runtime needs to be Int. QSearchState{S}, where S is the state type, is returned.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_single(qss, 4)\nQuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.438623\n  [3 ]  =  0.438623\n  [4 ]  =  0.438623\n  [5 ]  =  0.104937\n  [7 ]  =  0.254884\n  [8 ]  =  0.254884\n  [9 ]  =  0.104937\n  [10]  =  0.254884\n  [12]  =  0.254884\n  [13]  =  0.104937\n  [14]  =  0.254884\n  [15]  =  0.254884, [0.577169], 4)\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_single_measured-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.QWModelDiscr,Int64}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_single_measured",
    "category": "method",
    "text": "execute_single_measured(qss, [ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. The initial state is generated by initial_state(qss) function if not provided. runtime needs to be nonnegative. If qss is based on on QWModelDiscr, runtime needs to be Int. Probability measurement distribution is returned.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_single_measured(qss, 4)\n4-element Array{Float64,1}:\n 0.577169\n 0.140944\n 0.140944\n 0.140944\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_all-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_all",
    "category": "method",
    "text": "execute_all(qwd::QWDynamics{<:QWModelDiscr}, initstate, runtime)\n\nEvolve initstate acording to QWDynamics qwd for time runtime. Parameter runtime needs to be nonnegative and wqantum walk model needs to be discrete. Returns list of all states including the initstate and the final state.\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);\n\njulia> execute_all(qwe, initstate, 2)\n3-element Array{SparseVector{Float64,Int64},1}:\n   [1 ]  =  0.707107\n  [2 ]  =  0.707107\n   [1 ]  =  0.707107\n  [2 ]  =  0.0785674\n  [3 ]  =  -0.157135\n  [4 ]  =  -0.157135\n  [7 ]  =  0.31427\n  [8 ]  =  0.31427\n  [10]  =  -0.157135\n  [12]  =  0.31427\n  [14]  =  -0.157135\n  [15]  =  0.31427\n   [1 ]  =  0.707107\n  [2 ]  =  0.427756\n  [3 ]  =  -0.0698377\n  [4 ]  =  -0.0698377\n  [5 ]  =  -5.55112e-17\n  [7 ]  =  -0.174594\n  [8 ]  =  -0.174594\n  [9 ]  =  0.31427\n  [10]  =  -0.0698377\n  [12]  =  0.139675\n  [13]  =  0.31427\n  [14]  =  -0.0698377\n  [15]  =  0.139675\n\n\n\n\nexecute_all(qss::QSWSearch{<:QWModelDiscr},[ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. runtime needs to be nonnegative. The initial state is generated by initial_state(qss) function if not provided. Quantum walk model needs to be discrete. Returns list of all QSearchState{S} where S is state type including initstate  and last state.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_all(qss, 2)\n3-element Array{QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64},1}:\n QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.288675\n  [3 ]  =  0.288675\n  [4 ]  =  0.288675\n  [5 ]  =  0.288675\n  [7 ]  =  0.288675\n  [8 ]  =  0.288675\n  [9 ]  =  0.288675\n  [10]  =  0.288675\n  [12]  =  0.288675\n  [13]  =  0.288675\n  [14]  =  0.288675\n  [15]  =  0.288675, [0.25], 0)\n QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.481125\n  [3 ]  =  0.481125\n  [4 ]  =  0.481125\n  [5 ]  =  -0.288675\n  [7 ]  =  -0.096225\n  [8 ]  =  -0.096225\n  [9 ]  =  -0.288675\n  [10]  =  -0.096225\n  [12]  =  -0.096225\n  [13]  =  -0.288675\n  [14]  =  -0.096225\n  [15]  =  -0.096225, [0.694444], 1)\n QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  -0.138992\n  [3 ]  =  -0.138992\n  [4 ]  =  -0.138992\n  [5 ]  =  0.032075\n  [7 ]  =  -0.395592\n  [8 ]  =  -0.395592\n  [9 ]  =  0.032075\n  [10]  =  -0.395592\n  [12]  =  -0.395592\n  [13]  =  0.032075\n  [14]  =  -0.395592\n  [15]  =  -0.395592, [0.0579561], 2)\n\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_all_measured-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.QWModelDiscr,Int64}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_all_measured",
    "category": "method",
    "text": "execute_all_measured(qss::QWSearch{<:QWModelDiscr},[ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. runtime needs to be nonnegative. The initial state is generated by initial_state(qss) function if not provided.Quantum walk model needs to be discrete. As a result return matrix of type Matrix{Float64} for which i-th column  is measurement probability distribution in i-1-th step.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_all_measured(qss, 2)\n4×3 Array{Float64,2}:\n 0.25  0.694444  0.0579561\n 0.25  0.101852  0.314015\n 0.25  0.101852  0.314015\n 0.25  0.101852  0.314015\n\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.initial_state",
    "page": "Quantum search",
    "title": "QuantumWalk.initial_state",
    "category": "function",
    "text": "initial_state(qss)\n\nGenerates initial state for QWSearch qss. The type and value strongly depends on model of qss. For concrete model description please type ?initial_state(QWSearch{model}), for example for CTQW write ?initial_state(QWSearch{CTQW}).\n\nDetails concerning implementing initial_state for own models can be found in GitHub pages.\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.maximize_quantum_search",
    "page": "Quantum search",
    "title": "QuantumWalk.maximize_quantum_search",
    "category": "function",
    "text": "maximize_quantum_search(qss::QWSearch{<:QWModelCont} [, maxtime, tstep])\n\nDetermines optimal runtime for continuous quantum walk models. The time is searched in [0, maxtime] interval, with penalty penalty(qss), which is added. It is recommended for penalty to be nonzero, otherwise time close to 0 is usually returned. Typically small penalty approximately equal to log(n) is enough, but optimal value may depend on the model or graph chosen.\n\nThe optimal time is chosen according to expected runtime, which equals to runtime over probability, which simulates the Bernoulli process based on QWModelCont.\n\ntstep is used for primary grid search to search for determine intervale which is supsected to have small expected runtime. To large value may miss the optimal value, while to small may greatly increase runtime of the algorithm.\n\nmaxtime defaults to graph order n, tstep defaults to sqrt(n)/5. QSearchState is returned by deafult without penalty. Note that in general the probability is not maximal\n\njulia> using QuantumWalk,LightGraphs\n\njulia> qss = QWSearch(CTQW(CompleteGraph(100)), [1], 0.01, 1.);\n\njulia> result = maximize_quantum_search(qss)\nQuantumWalk.QSearchState{Array{Complex{Float64},1},Float64}(Complex{Float64}[0.621142+0.695665im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im  …  0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im], [0.869767], 12.99636940469214)\n\njulia> expected_runtime(result)\n14.94235723559316\n\njulia> probability(result)\n1-element Array{Float64,1}:\n 0.869767\n\njulia> probability(execute_single(qss, pi*sqrt(100)/2))\n1-element Array{Float64,1}:\n 1.0\n\n\n\nmaximize_quantum_search(qss::QWSearch{<:QWModelDiscr} [, runtime, mode])\n\nDetermines optimal runtime for continuous quantum walk models. The time is searched in [0, runtime] interval, with penalty penalty(qss), which is added. It is recommended for penalty to be nonzero, otherwise time close 0 is returned. Typically small penalty approximately equal to log(n) is enough, but optimal value may depend on the model or graph chosen.\n\nThe optimal time depende on chosen mode:\n\n:firstmaxprob stops when probability start to decrease,\n:firstmaxeff stops whene expected runtime start to increase,\n:maxtimeeff chooses exhaustively the time from [0, runtime] with smallest expected time,\n:maxtimeprob chooses exhaustively the time from [0, runtime] with maximal success probability,\n:maxeff (default) finds optimal time with smallest expected time, usually faster\n\nthan :maxtimefff.\n\nNote last three modes always returns optimal time within the interval.\n\nmaxtime defaults to graph order n, mode defaults to :maxeff. QSearchState is returned by deafult without penalty.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(200)), [1], 1);\n\njulia> result = maximize_quantum_search(qss);\n\njulia> runtime(result)\n7\n\njulia> probability(result)\n1-element Array{Float64,1}:\n 0.500016\n\njulia> result = maximize_quantum_search(qss, 100, :maxtimeprob);\n\njulia> runtime(result)\n40\n\njulia> probability(result)\n1-element Array{Float64,1}:\n 0.550938\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.QSearchState",
    "page": "Quantum search",
    "title": "QuantumWalk.QSearchState",
    "category": "type",
    "text": "QSearchState(state, probability, runtime)\nQSearchState(qss, state, runtime)\n\nCreates container which consists of state, success probability probability and running time runtime. Validity of probability and runtime is not checked.\n\nIn second case state is measured according to qss is made.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = QSearchState(qss, initial_state(qss), 0)\nQuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.288675\n  [3 ]  =  0.288675\n  [4 ]  =  0.288675\n  [5 ]  =  0.288675\n  [7 ]  =  0.288675\n  [8 ]  =  0.288675\n  [9 ]  =  0.288675\n  [10]  =  0.288675\n  [12]  =  0.288675\n  [13]  =  0.288675\n  [14]  =  0.288675\n  [15]  =  0.288675, [0.25], 0)\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.state",
    "page": "Quantum search",
    "title": "QuantumWalk.state",
    "category": "function",
    "text": "state(qsearchstate)\n\nReturns the state of qsearchstate.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = QSearchState(qss, initial_state(qss), 0);\n\njulia> state(result)\n16-element SparseVector{Float64,Int64} with 12 stored entries:\n  [2 ]  =  0.288675\n  [3 ]  =  0.288675\n  [4 ]  =  0.288675\n  [5 ]  =  0.288675\n  [7 ]  =  0.288675\n  [8 ]  =  0.288675\n  [9 ]  =  0.288675\n  [10]  =  0.288675\n  [12]  =  0.288675\n  [13]  =  0.288675\n  [14]  =  0.288675\n  [15]  =  0.288675\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.probability",
    "page": "Quantum search",
    "title": "QuantumWalk.probability",
    "category": "function",
    "text": "probability(qsearchstate)\n\nReturns the list of probabilities of finding marked vertices.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = QSearchState(qss, initial_state(qss), 0);\n\njulia> probability(result)\n1-element Array{Float64,1}:\n 0.25\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.runtime",
    "page": "Quantum search",
    "title": "QuantumWalk.runtime",
    "category": "function",
    "text": "runtime(qsearchstate)\n\nReturns the time for which the state was calulated.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = QSearchState(qss, initial_state(qss), 0);\n\njulia> runtime(result)\n0\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.expected_runtime",
    "page": "Quantum search",
    "title": "QuantumWalk.expected_runtime",
    "category": "function",
    "text": "expected_runtime(runtime, probability)\nexpected_runtime(state)\n\nReturns the expected runtime needed for quantum walk, considering it as Bernoulli process. It equals to runtime/probability. In the case of state provided the measurement is made.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = execute(qss, 4);\n\njulia> expected_runtime(result)\n6.930377097077988\n\njulia> expected_runtime(runtime(result), sum(probability(result)))\n6.930377097077988\n\n\n\n"
},

{
    "location": "quantum_search.html#Full-docs-1",
    "page": "Quantum search",
    "title": "Full docs",
    "category": "section",
    "text": "QWSearch\nmarked(qss::QWSearch)\npenalty(qss::QWSearch)\ncheck_qwdynamics(::QWSearch, ::Vector{Int}, ::Dict{Symbol})\nexecute(::QWSearch, ::Real)\nexecute_single(qss::QWSearch{<:QWModelDiscr}, initstate, runtime::Int)\nexecute_single(qss::QWSearch{<:QWModelCont}, initstate, runtime::Real)\nexecute_single(qss::QWSearch, runtime::Real)\nexecute_single_measured(::QWSearch{<:QWModelDiscr}, ::Int)\nexecute_all(::QWSearch{<:QWModelDiscr}, ::Any, ::Int)\nexecute_all_measured(::QWSearch{<:QWModelDiscr}, ::Int)\ninitial_state\nmaximize_quantum_search\nQSearchState\nstate\nprobability\nruntime\nexpected_runtime"
},

{
    "location": "ctqw.html#",
    "page": "CTQW model",
    "title": "CTQW model",
    "category": "page",
    "text": "DocTestSetup = quote\n   using QuantumWalk, LightGraphs\nend"
},

{
    "location": "ctqw.html#Continuous-Time-Quantum-Walk-1",
    "page": "CTQW model",
    "title": "Continuous-Time Quantum Walk",
    "category": "section",
    "text": "Exemplary implementation of continuous quantum walk. The model is defined for arbitrary undirected graph. Hamiltonian is chosen to be adjacency or Laplacian matrix. The evolutions starts in equal superposition, and after time it is measured in canonic basis. The evolution is made on the pure system of size equal to graph order. The precise definition can be found in Spatial search by quantum walk, written by Childs and Goldstone, where both pure walk and search dynamics are described.The abstract supertype is AbstractCTQW with its default realization CTQW. The model includes following types and methods:Order = [:type, :function]\nModules = [QuantumWalk]\nPages   = [\"ctqw.md\"]"
},

{
    "location": "ctqw.html#QuantumWalk.AbstractCTQW",
    "page": "CTQW model",
    "title": "QuantumWalk.AbstractCTQW",
    "category": "type",
    "text": "AbstractCTQW\n\nAbstract CTQW model. By default evolve according to Schrödinger equation and performs measurmenet by taking square of absolute values of its elements. Default representation of AbstractCTQW is CTQW.\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.CTQW",
    "page": "CTQW model",
    "title": "QuantumWalk.CTQW",
    "category": "type",
    "text": "CTQW(graph[, matrix])\n\nDefault representation of AbstractCTQW. graph needs to be of type Graph from LightGraphs module, matrix needs to be :adjacency or :laplacian and defaults to :adjacency.\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.QWEvolution-Union{Tuple{Type{U},QuantumWalk.AbstractCTQW}, Tuple{U}} where U<:Number",
    "page": "CTQW model",
    "title": "QuantumWalk.QWEvolution",
    "category": "method",
    "text": "QWEvolution([type, ]ctqw::AbstractCTQW)\n\nCreates QWEvolution according to AbstractCTQW model. By default type equals Complex128. By default constructed hamiltonian is SparseMatrixCSC.\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.QWSearch-Union{Tuple{T}, Tuple{Type{T},QuantumWalk.AbstractCTQW,Array{Int64,N} where N,T,Real}, Tuple{Type{T},QuantumWalk.AbstractCTQW,Array{Int64,N} where N,T}} where T<:Number",
    "page": "CTQW model",
    "title": "QuantumWalk.QWSearch",
    "category": "method",
    "text": "QWSearch([type, ]ctqw::AbstractCTQW, marked [, jumpingrate, penalty])\n\nCreates QWSearch according to AbstractCTQW model. By default type equals Complex128, jumpingrate equals largest eigenvalue of adjacency matrix of graph if matrix(CTQW) outputs :adjacency and error otherwise, and penalty equals 0. By default hamiltonian is SparseMatrixCSC.\n\nQWSearch(qss::QWSearch{<:CTQW}; marked, penalty)\n\nUpdates quantum walk search to new subset of marked elements and new penalty. By default marked and penalty are the same as in qss.\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.check_qwdynamics-Tuple{Type{QuantumWalk.QWSearch},QuantumWalk.AbstractCTQW,Array{Int64,N} where N,Dict{Symbol,V} where V}",
    "page": "CTQW model",
    "title": "QuantumWalk.check_qwdynamics",
    "category": "method",
    "text": "check_qwdynamics(ctqw::AbstractCTQW, marked, parameters)\n\nChecks whetver combination of ctqw, marked and parameters produces valid QWSearch object. It checks where parameters consists of key :hamiltonian with corresponding value being SparseMatrixCSC or Matrix. Furthermore the hamiltonian needs to be square of size equals to graph(ctqw) order.\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.check_qwdynamics-Tuple{Type{QuantumWalk.QWEvolution},QuantumWalk.AbstractCTQW,Dict{Symbol,V} where V}",
    "page": "CTQW model",
    "title": "QuantumWalk.check_qwdynamics",
    "category": "method",
    "text": "check_qwdynamics(ctqw::AbstractCTQW, parameters)\n\nChecks whetver combination of ctqw and parameters produces valid QWSearch object. It checks where parameters consists of key :hamiltonian with corresponding value being SparseMatrixCSC or Matrix. Furthermore the hamiltonian needs to be square of size equals to graph(ctqw) order.\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.evolve-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.AbstractCTQW,Array{#s15,1} where #s15<:Number,Real}",
    "page": "CTQW model",
    "title": "QuantumWalk.evolve",
    "category": "method",
    "text": "evolve(qwd, state, runtime)\n\nReturnes new state creates by evolving state by qwd.parameters[:hamiltonian] for time runtime according to Schrödinger equation.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1]);\n\njulia> evolve(qss, initial_state(qss), 1.)\n4-element Array{Complex{Float64},1}:\n -0.128942+0.67431im\n  0.219272+0.357976im\n  0.219272+0.357976im\n  0.219272+0.357976im\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.initial_state-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.AbstractCTQW}",
    "page": "CTQW model",
    "title": "QuantumWalk.initial_state",
    "category": "method",
    "text": "initial_state(qss::QWSearch{AbstractCTQW})\n\nReturns equal superposition of size size and type of qss.parameters[:hamiltonian].\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1]);\n\njulia> initial_state(qss)\n4-element Array{Complex{Float64},1}:\n 0.5+0.0im\n 0.5+0.0im\n 0.5+0.0im\n 0.5+0.0im\n\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.matrix-Tuple{QuantumWalk.AbstractCTQW}",
    "page": "CTQW model",
    "title": "QuantumWalk.matrix",
    "category": "method",
    "text": "matrix(ctqw::AbstractCTQW)\n\nReturns the matrix symbol defining matrix graph used.\n\njulia> matrix(CTQW(CompleteGraph(4)))\n:adjacency\n\njulia> matrix(CTQW(CompleteGraph(4), :laplacian))\n:laplacian\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.measure-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.AbstractCTQW,Any}",
    "page": "CTQW model",
    "title": "QuantumWalk.measure",
    "category": "method",
    "text": "measure(qwd::QWDynamics{<:AbstractCTQW}, state [, vertices])\n\nReturns the probability of measuring each vertex from vertices from state according to AbstractCTQW model. If vertices is not provided, full measurement is made. For AbstractCTQW model measurement is done by taking square of absolute value of all elements of state.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1]);\n\njulia> measure(qss, [sqrt(0.2), sqrt(0.3), sqrt(0.5)])\n3-element Array{Float64,1}:\n 0.2\n 0.3\n 0.5\n\njulia> measure(qss, [sqrt(0.2), sqrt(0.3), sqrt(0.5)], [2, 3])\n2-element Array{Float64,1}:\n 0.3\n 0.5\n\n\n\n\n"
},

{
    "location": "ctqw.html#Full-docs-1",
    "page": "CTQW model",
    "title": "Full docs",
    "category": "section",
    "text": "AbstractCTQW\nCTQW\nQWEvolution(::Type{U}, ::AbstractCTQW) where U<:Number\nQWSearch(::Type{T}, ::AbstractCTQW, ::Array{Int}, ::T, ::Real = 0.) where T<:Number\ncheck_qwdynamics(::Type{QWSearch}, ::AbstractCTQW, ::Array{Int}, ::Dict{Symbol})\ncheck_qwdynamics(::Type{QWEvolution}, ::AbstractCTQW, ::Dict{Symbol})\nevolve(::QWDynamics{<:AbstractCTQW}, ::Vector{<:Number}, ::Real)\ninitial_state(::QWSearch{<:AbstractCTQW})\nmatrix(::AbstractCTQW)\nmeasure(::QWDynamics{<:AbstractCTQW}, ::Any)"
},

{
    "location": "szegedy.html#",
    "page": "Szegedy model",
    "title": "Szegedy model",
    "category": "page",
    "text": "DocTestSetup = quote\n   using QuantumWalk, LightGraphs\nend"
},

{
    "location": "szegedy.html#Szegedy-Quantum-Walk-1",
    "page": "Szegedy model",
    "title": "Szegedy Quantum Walk",
    "category": "section",
    "text": "The Szegedy quantum walk is one of the most popular discrete quantum walk models. It takes stochastic matrix, turns it into unitary operator and use it for evolution. The evolution is purely unitary on the dimension equal to square of the graph order. The definition can be found in Quantum speed-up of Markov chain based algorithms, by Szegedy. The definition of quantum search can be found in Direct Equivalence of Coined and Szegedy\'s Quantum Walks, by Wong.The abstract supertype is AbstractSzegedy with its default realization Szegedy The model includes following types and methods:Order = [:type, :function]\nModules = [QuantumWalk]\nPages   = [\"szegedy.md\"]"
},

{
    "location": "szegedy.html#QuantumWalk.AbstractSzegedy",
    "page": "Szegedy model",
    "title": "QuantumWalk.AbstractSzegedy",
    "category": "type",
    "text": "AbstractSzegedy\n\nAbstract Szegedy model. Description of the default parameter can be found in https://arxiv.org/abs/1611.02238, where two oracle operator case is chosen. Default representation of AbstractSzegedy is Szegedy.\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.QWEvolution-Tuple{QuantumWalk.AbstractSzegedy}",
    "page": "Szegedy model",
    "title": "QuantumWalk.QWEvolution",
    "category": "method",
    "text": "QWEvolution(szegedy::AbstractSzegedy)\n\nCreate QWEvolution according to AbstractSzegedy model. By default, the constructed operator is of type SparseMatrixCSC.\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.QWSearch-Tuple{QuantumWalk.AbstractSzegedy,Array{Int64,N} where N,Real}",
    "page": "Szegedy model",
    "title": "QuantumWalk.QWSearch",
    "category": "method",
    "text": "QWSearch(szegedy::AbstractSzegedy, marked [, penalty])\n\nCreates QWSearch according to AbstractSzegedy model. By default parameter penalty is set to 0. Evolution operators are constructed according to the definition from https://arxiv.org/abs/1611.02238.\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.Szegedy",
    "page": "Szegedy model",
    "title": "QuantumWalk.Szegedy",
    "category": "type",
    "text": "Szegedy(graph[, stochastic, checkstochastic])\n\nDefault representation of AbstractSzegedy. Parameter graph needs to be a  subtype of AbstractGraph from LightGraphs module, and parameter stochastic  needs to be a Real column stochastic matrix. Flag checkstochastic decides  about checking the stochastic properties.\n\nMatrix stochastic defaults to the uniform walk operator, and  checkstochastic deafults to false in case of default stochastic. If  matrix stochastic is provided by the user, the default value of stochastic  is true.\n\nMatrix stochastic is changed into sqrtstochastic by taking element-wise  square root.\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.check_qwdynamics-Tuple{Type{QuantumWalk.QWSearch},QuantumWalk.AbstractSzegedy,Array{Int64,N} where N,Dict{Symbol,V} where V}",
    "page": "Szegedy model",
    "title": "QuantumWalk.check_qwdynamics",
    "category": "method",
    "text": "check_qwdynamics(szegedy::AbstractSzegedy, marked, parameters)\n\nCheck whetver combination of szegedy, marked and parameters produces valid QWSearch object. It checks where parameters consists of key :operators with corresponding value being list of SparseMatrixCSC. Furthermore operators needs to be square of size equals to square of graph(szegedy). order.\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.check_qwdynamics-Tuple{Type{QuantumWalk.QWEvolution},QuantumWalk.AbstractSzegedy,Dict{Symbol,V} where V}",
    "page": "Szegedy model",
    "title": "QuantumWalk.check_qwdynamics",
    "category": "method",
    "text": "check_qwdynamics(szegedy::AbstractSzegedy, marked, parameters)\n\nCheck whetver combination of szegedy, marked and parameters produces a valid QWEvolution object. It checks where parameters consists of key :operators with corresponding value being a list of SparseMatrixCSC objects. Furthermore operators need to be square of size equals to square of the order of graph(szegedy).\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.evolve-Union{Tuple{QuantumWalk.QWDynamics{QuantumWalk.Szegedy{#s16,T} where #s16},SparseVector{T,Ti} where Ti<:Integer}, Tuple{T}} where T<:Number",
    "page": "Szegedy model",
    "title": "QuantumWalk.evolve",
    "category": "method",
    "text": "evolve(qwe::QWSearch{AbstractSzegedy}, state)\n\nMultiplies state be each operator from operators from quatnum walk evolution qwe. Elements of operators and state should be of the same type.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> evolve(qss, initial_state(qss))\n16-element SparseVector{Float64,Int64} with 12 stored entries:\n  [2 ]  =  0.481125\n  [3 ]  =  0.481125\n  [4 ]  =  0.481125\n  [5 ]  =  -0.288675\n  [7 ]  =  -0.096225\n  [8 ]  =  -0.096225\n  [9 ]  =  -0.288675\n  [10]  =  -0.096225\n  [12]  =  -0.096225\n  [13]  =  -0.288675\n  [14]  =  -0.096225\n  [15]  =  -0.096225\n\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.initial_state-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.AbstractSzegedy}",
    "page": "Szegedy model",
    "title": "QuantumWalk.initial_state",
    "category": "method",
    "text": "initial_state(qss::QWSearch{<:AbstractSzegedy})\n\nGenerates typical initial state for Szegedy search, see https://arxiv.org/abs/1611.02238. Vectorizes and normalizes obtained sqrtstochastic matrix from model(qss). Note that the state may not be uniform supersposition in general, but it gives uniform superposition after partial tracing second system.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> initial_state(qss)\n16-element SparseVector{Float64,Int64} with 12 stored entries:\n  [2 ]  =  0.288675\n  [3 ]  =  0.288675\n  [4 ]  =  0.288675\n  [5 ]  =  0.288675\n  [7 ]  =  0.288675\n  [8 ]  =  0.288675\n  [9 ]  =  0.288675\n  [10]  =  0.288675\n  [12]  =  0.288675\n  [13]  =  0.288675\n  [14]  =  0.288675\n  [15]  =  0.288675\n\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.measure-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.AbstractSzegedy,SparseVector{#s15,Ti} where Ti<:Integer where #s15<:Number}",
    "page": "Szegedy model",
    "title": "QuantumWalk.measure",
    "category": "method",
    "text": "measure(qwd::AbstractSzegedy, state[, vertices])\n\nPerformes a measurement on state on vertices. vertices defaults to list of all vertices. It is defined as the measurement of partially traced on second system state https://arxiv.org/abs/1611.02238.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> state = evolve(qss, initial_state(qss));\n\njulia> measure(qss, state)\n4-element Array{Float64,1}:\n 0.694444\n 0.101852\n 0.101852\n 0.101852\n\njulia> measure(qss, state, [1,3])\n2-element Array{Float64,1}:\n 0.694444\n 0.101852\n\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.sqrtstochastic",
    "page": "Szegedy model",
    "title": "QuantumWalk.sqrtstochastic",
    "category": "function",
    "text": "sqrtstochastic(szegedy)\n\nReturn the sqrtstochastic element of szegedy. After element-wise squaring a column-stochastic matrix is obtained.\n\njulia> szegedy = Szegedy(CompleteGraph(4));\n\njulia> sqrtstochastic(szegedy)\n4×4 SparseMatrixCSC{Float64,Int64} with 12 stored entries:\n  [2, 1]  =  0.57735\n  [3, 1]  =  0.57735\n  [4, 1]  =  0.57735\n  [1, 2]  =  0.57735\n  [3, 2]  =  0.57735\n  [4, 2]  =  0.57735\n  [1, 3]  =  0.57735\n  [2, 3]  =  0.57735\n  [4, 3]  =  0.57735\n  [1, 4]  =  0.57735\n  [2, 4]  =  0.57735\n  [3, 4]  =  0.57735\n\njulia> full(sqrtstochastic(szegedy).^2)\n4×4 Array{Float64,2}:\n 0.0       0.333333  0.333333  0.333333\n 0.333333  0.0       0.333333  0.333333\n 0.333333  0.333333  0.0       0.333333\n 0.333333  0.333333  0.333333  0.0\n\n\n\n"
},

{
    "location": "szegedy.html#Full-docs-1",
    "page": "Szegedy model",
    "title": "Full docs",
    "category": "section",
    "text": "AbstractSzegedy\nQWEvolution(::AbstractSzegedy)\nQWSearch(::AbstractSzegedy, ::Array{Int}, ::Real)\nSzegedy\ncheck_qwdynamics(::Type{QWSearch}, ::AbstractSzegedy, ::Array{Int}, ::Dict{Symbol})\ncheck_qwdynamics(::Type{QWEvolution}, ::AbstractSzegedy, ::Dict{Symbol})\nevolve(::QWDynamics{Szegedy{<:Any,T}}, ::SparseVector{T}) where T<:Number\ninitial_state(::QWSearch{<:AbstractSzegedy})\nmeasure(::QWDynamics{<:AbstractSzegedy}, ::SparseVector{<:Number})\nsqrtstochastic"
},

{
    "location": "new_dynamics.html#",
    "page": "New dynamics",
    "title": "New dynamics",
    "category": "page",
    "text": "TODO"
},

{
    "location": "contributing.html#",
    "page": "Contributing",
    "title": "Contributing",
    "category": "page",
    "text": ""
},

{
    "location": "contributing.html#Contributing-1",
    "page": "Contributing",
    "title": "Contributing",
    "category": "section",
    "text": "TODO: wstep (Jarek)Please do not send pull request before an issue."
},

{
    "location": "contributing.html#Bugs-1",
    "page": "Contributing",
    "title": "Bugs",
    "category": "section",
    "text": "In the case you noticed some bugs, please start with an issue with minimal working example of not-working code. If Exception is thrown, please provide an exception message as well. If no Exception is thrown, but the result is wrong, please provide in the issue message an correct answer.In the case you make a pull request, please add not working example as a test."
},

{
    "location": "contributing.html#Improvements-1",
    "page": "Contributing",
    "title": "Improvements",
    "category": "section",
    "text": "If you can provide a code, which works faster than already existing, please check its efficiency for various input data. In particular check various dynamics and graphs. Typically checked graphs are Path  and Complete graphs.We are aware of the fact, that the efficiency of the quantum walk model evolution may depend strongly on the graph properties, including order and sparsity. If your implementation works better only on some collection, please provide it as separate model, possible as subtype of already existing model if possible. Note we are interested in the implementation which works well for many parameters, not only for example for path graphs.We welcome as well any ideas concerning the readability and logic of the code."
},

{
    "location": "contributing.html#Development-guidelines-1",
    "page": "Contributing",
    "title": "Development guidelines",
    "category": "section",
    "text": "Post an issue,\nwait until the discussion ends :),\ncheck the name convention from already existing model,\ntry to make your code as general as possible, for example\ncheck if the general functions as measure or evolve are defined forabstract supertype (if you provide such),check the requirements for model/dynamics. If possible, extend them.\ncreate assertions on argument types and other requirements,\ninclude necessary references,\nwrite tests."
},

{
    "location": "citing.html#",
    "page": "Citing",
    "title": "Citing",
    "category": "page",
    "text": ""
},

{
    "location": "citing.html#Usage-nad-citing-1",
    "page": "Citing",
    "title": "Usage nad citing",
    "category": "section",
    "text": "In case of citing, please use the following BibTeX form:@misc{glos2018quantumwalkjl,\n  author       = {Adam Glos and Jaros{\\l}aw Adam Miszczak},\n  title        = {{QuantumWalks/QuantumWalk.jl}},\n  year         = {2018},\n  url          = {https://github.com/QuantumWalks/QuantumWalk.jl}\n}Our package was already used in papers concerning quantum attacksAdam Glos, Jarosław Adam Miszczak. \'Impact of the malicious input data modification on the efficiency of quantum algorithms.\' arXiv preprint arXiv:1802.10041 (2018).In case You have used our package for your research, we will be grateful for any information about the paper or the package. With your consent we will provide an link to the paper here."
},

{
    "location": "license.html#",
    "page": "Licence",
    "title": "Licence",
    "category": "page",
    "text": "MIT LicenseCopyright (c) 2017 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
},

]}
