var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": "Welcome to QuantumWalk.jl package."
},

{
    "location": "type_hierarchy.html#",
    "page": "Type hierarchy",
    "title": "Type hierarchy",
    "category": "page",
    "text": ""
},

{
    "location": "type_hierarchy.html#Quantum-Walk-models-1",
    "page": "Type hierarchy",
    "title": "Quantum Walk models",
    "category": "section",
    "text": ""
},

{
    "location": "type_hierarchy.html#Full-docs-1",
    "page": "Type hierarchy",
    "title": "Full docs",
    "category": "section",
    "text": ""
},

{
    "location": "type_hierarchy.html#QuantumWalk.QWModel",
    "page": "Type hierarchy",
    "title": "QuantumWalk.QWModel",
    "category": "Type",
    "text": "QWModel\n\nAbstract supertype of all quantum walk models.\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.QWModelCont",
    "page": "Type hierarchy",
    "title": "QuantumWalk.QWModelCont",
    "category": "Type",
    "text": "QWModelCont\n\nAbstract supertype of all continuous quantum walk models.\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.QWModelDiscr",
    "page": "Type hierarchy",
    "title": "QuantumWalk.QWModelDiscr",
    "category": "Type",
    "text": "QWModelDiscr\n\nAbstract supertype of all discrete quantum walk models.\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.graph-Tuple{QuantumWalk.QWModel}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.graph",
    "category": "Method",
    "text": "graph(model)\n\nReturns graph element of model.\n\njulia> ctqw = CTQW(CompleteGraph(4))\nQuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency)\n\njulia> graph(ctqw)\n{4, 6} undirected simple Int64 graph\n\n\n\n\n"
},

{
    "location": "type_hierarchy.html#Types-and-its-function-1",
    "page": "Type hierarchy",
    "title": "Types and its function",
    "category": "section",
    "text": "QWModel\nQWModelCont\nQWModelDiscr\ngraph(::QWModel)"
},

{
    "location": "type_hierarchy.html#Quantum-Dynamics-1",
    "page": "Type hierarchy",
    "title": "Quantum Dynamics",
    "category": "section",
    "text": ""
},

{
    "location": "type_hierarchy.html#Full-docs-2",
    "page": "Type hierarchy",
    "title": "Full docs",
    "category": "section",
    "text": ""
},

{
    "location": "type_hierarchy.html#QuantumWalk.QWDynamics",
    "page": "Type hierarchy",
    "title": "QuantumWalk.QWDynamics",
    "category": "Type",
    "text": "QWDynamics{T<:QWModel}\n\nAbstract supertype of all dynamics on quantum walk models.\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.model",
    "page": "Type hierarchy",
    "title": "QuantumWalk.model",
    "category": "Function",
    "text": "model(qwd)\n\nReturns model element of qwd.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> model(qss)\nQuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency)\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.graph-Tuple{QuantumWalk.QWDynamics}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.graph",
    "category": "Method",
    "text": "graph(qwd)\n\nReturns graph element of model from qwd. Equivalent to graph(model(qwd)).\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> graph(qss)\n{4, 6} undirected simple Int64 graph\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.parameters",
    "page": "Type hierarchy",
    "title": "QuantumWalk.parameters",
    "category": "Function",
    "text": "parameters(qwd)\n\nReturns parameters element of qwd.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> parameters(qss)\nDict{Symbol,Any} with 1 entry:\n  :hamiltonian => …\n\n\n\n\n"
},

{
    "location": "type_hierarchy.html#Types-and-its-function-2",
    "page": "Type hierarchy",
    "title": "Types and its function",
    "category": "section",
    "text": "QWDynamics\nmodel\ngraph(::QWDynamics)\nparameters"
},

{
    "location": "type_hierarchy.html#QuantumWalk.execute-Tuple{QuantumWalk.QWDynamics,Any,Real}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.execute",
    "category": "Method",
    "text": "execute(qwd, initstate, runtime[, all, measure])\n\nRun proper execution function depending on given keywords. all and measure keywords defaults to false. For detailed description please see documentation of the corresponding function. Note that for all equal to true, the model specified by qwd needs to be disrete.\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.execute_single-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.execute_single",
    "category": "Method",
    "text": "execute_single(qwd, initstate, runtime)\n\nEvolve initstate acording to QWDynamics qwd for time runtime. Parameter runtime needs to be nonnegative. If qwd subtype of QWModelDiscr, runtime needs to be of type Int.\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);\n\njulia> execute_single(qwe, initstate, 10)\n16-element SparseVector{Float64,Int64} with 13 stored entries:\n  [1 ]  =  0.707107\n  [2 ]  =  0.6615\n  [3 ]  =  -0.0114017\n  [4 ]  =  -0.0114017\n  [5 ]  =  -1.21431e-16\n  [7 ]  =  -0.111417\n  [8 ]  =  -0.111417\n  [9 ]  =  0.13422\n  [10]  =  -0.0114017\n  [12]  =  0.0228034\n  [13]  =  0.13422\n  [14]  =  -0.0114017\n  [15]  =  0.0228034\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.execute_single_measured-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.execute_single_measured",
    "category": "Method",
    "text": "execute_single_measured(qwd, initstate, runtime)\n\nEvolve initstate acording to QWDynamics qwd for time runtime and measure it in the end. Parameter runtime needs to be nonnegative. If qwd is subtype of QWModelDiscr, runtime needs to be Int.\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);\n\njulia> execute_single_measured(qwe, initstate, 10)\n4-element Array{Float64,1}:\n 0.937842\n 0.0248275\n 0.0186651\n 0.0186651\n\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.execute_all-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.execute_all",
    "category": "Method",
    "text": "execute_all(qwd::QWDynamics{<:QWModelDiscr}, initstate, runtime)\n\nEvolve initstate acording to QWDynamics qwd for time runtime. Parameter runtime needs to be nonnegative and wqantum walk model needs to be discrete. Returns list of all states including the initstate and the final state.\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);\n\njulia> execute_all(qwe, initstate, 2)\n3-element Array{SparseVector{Float64,Int64},1}:\n   [1 ]  =  0.707107\n  [2 ]  =  0.707107\n   [1 ]  =  0.707107\n  [2 ]  =  0.0785674\n  [3 ]  =  -0.157135\n  [4 ]  =  -0.157135\n  [7 ]  =  0.31427\n  [8 ]  =  0.31427\n  [10]  =  -0.157135\n  [12]  =  0.31427\n  [14]  =  -0.157135\n  [15]  =  0.31427\n   [1 ]  =  0.707107\n  [2 ]  =  0.427756\n  [3 ]  =  -0.0698377\n  [4 ]  =  -0.0698377\n  [5 ]  =  -5.55112e-17\n  [7 ]  =  -0.174594\n  [8 ]  =  -0.174594\n  [9 ]  =  0.31427\n  [10]  =  -0.0698377\n  [12]  =  0.139675\n  [13]  =  0.31427\n  [14]  =  -0.0698377\n  [15]  =  0.139675\n\n\n\n\n"
},

{
    "location": "type_hierarchy.html#QuantumWalk.execute_all_measured-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Type hierarchy",
    "title": "QuantumWalk.execute_all_measured",
    "category": "Method",
    "text": "execute_all_measured(qwd::QWDynamics{<:QWModelDiscr}, initstate, runtime)\n\nEvolve initstate acording to QWDynamics qwd for time runtime. Parameter runtime needs to be nonnegative and quantum walk model needs to be discrete. Returns matrix of type Matrix{Float64} for which i-th column  is the probability distribution obtained from the measurement in i-1-th step.\n\njulia> qwe = QWEvolution(Szegedy(CompleteGraph(4)));\n\njulia> initstate = spzeros(16); initstate[1] = initstate[2] = 1/sqrt(2.);\n\njulia> execute_all_measured(qwe, initstate, 2)\n4×3 Array{Float64,2}:\n 1.0  0.555556  0.69273\n 0.0  0.197531  0.0609663\n 0.0  0.123457  0.123152\n 0.0  0.123457  0.123152\n\n\n\n\n"
},

{
    "location": "type_hierarchy.html#Functions-1",
    "page": "Type hierarchy",
    "title": "Functions",
    "category": "section",
    "text": "execute(::QWDynamics, ::Any, ::Real)\nexecute_single(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)\nexecute_single_measured(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)\nexecute_all(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)\nexecute_all_measured(::QWDynamics{<:QWModelDiscr}, ::Any, ::Int)"
},

{
    "location": "quantum_walk.html#",
    "page": "Quantum walk simulator",
    "title": "Quantum walk simulator",
    "category": "page",
    "text": ""
},

{
    "location": "quantum_walk.html#Quantum-Search-1",
    "page": "Quantum walk simulator",
    "title": "Quantum Search",
    "category": "section",
    "text": ""
},

{
    "location": "quantum_walk.html#Full-docs-1",
    "page": "Quantum walk simulator",
    "title": "Full docs",
    "category": "section",
    "text": ""
},

{
    "location": "quantum_walk.html#QuantumWalk.QWEvolution",
    "page": "Quantum walk simulator",
    "title": "QuantumWalk.QWEvolution",
    "category": "Type",
    "text": "QWEvolution(model, parameters)\n\nType describing standard quantum walk evolution. Needs implementation of\n\nevolve(::QWEvolution{<:QWModelDiscr}, state) or evolve(::QWEvolution{<:QWModelCont}, state, time::Real)\nmeasure(::QWEvolution, state)\ncheck_qwevolution(::QWModelDiscr, parameters::Dict{Symbol})\nproper constructors.\n\nOffers functions\n\nexecute\nexecute_single\nexecute_single_measured\nexecute_all\nexecute_all_measured\n\n\n\n"
},

{
    "location": "quantum_walk.html#QuantumWalk.check_qwevolution",
    "page": "Quantum walk simulator",
    "title": "QuantumWalk.check_qwevolution",
    "category": "Function",
    "text": "check_qwevolution(model, parameters)\n\nChecks whetver combination of model and parameters creates valid quantum walk simulator.\n\nDetails concerning implementing check_qws for own models can be found in GitHub pages.\n\n\n\n"
},

{
    "location": "quantum_walk.html#Types-and-its-function-1",
    "page": "Quantum walk simulator",
    "title": "Types and its function",
    "category": "section",
    "text": "QWEvolutioncheck_qwevolution"
},

{
    "location": "quantum_search.html#",
    "page": "Quantum search",
    "title": "Quantum search",
    "category": "page",
    "text": "Depth = 4"
},

{
    "location": "quantum_search.html#Quantum-Search-1",
    "page": "Quantum search",
    "title": "Quantum Search",
    "category": "section",
    "text": ""
},

{
    "location": "quantum_search.html#Full-docs-1",
    "page": "Quantum search",
    "title": "Full docs",
    "category": "section",
    "text": ""
},

{
    "location": "quantum_search.html#QuantumWalk.QWSearch",
    "page": "Quantum search",
    "title": "QuantumWalk.QWSearch",
    "category": "Type",
    "text": "QWSearch(model, marked, parameters, penalty)\n\nSimulates quantum search on model with marked vertices and additional parameters. penalty represents the cost of initial state creation and measurement, which should be included for better optimization, see documentation of maximizing_function.\n\nNeeds implementation of\n\ninitial_state(::QWEvolution)\nevolve(::QWEvolution{<:QWModelDiscr}, state) or evolve(::QWEvolution{<:QWModelCont}, state, time::Real)\nmeasure(::QWEvolution, state)\ncheck_qwsearch(::QWModelDiscr, parameters::Dict{Symbol})\nproper constructors.\n\nOffers functions\n\nexecute\nexecute_single\nexecute_single_measured\nexecute_all\nexecute_all_measured\nmaximize_quantum_search\nexpected_runtime\n\nand type QSearchState.\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.marked",
    "page": "Quantum search",
    "title": "QuantumWalk.marked",
    "category": "Function",
    "text": "marked(qss)\n\nReturns marked element of qss.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> marked(qss)\n1-element Array{Int64,1}:\n  1\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.penalty",
    "page": "Quantum search",
    "title": "QuantumWalk.penalty",
    "category": "Function",
    "text": "penalty(qss)\n\nReturns penalty element of qss.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1])\nQuantumWalk.QWSearch{QuantumWalk.CTQW,Float64}(QuantumWalk.CTQW({4, 6} undirected simple Int64 graph, :adjacency), [1], Dict{Symbol,Any}(Pair{Symbol,Any}(:hamiltonian,\n  [1, 1]  =  1.0+0.0im\n  [2, 1]  =  0.333333+0.0im\n  [3, 1]  =  0.333333+0.0im\n  [4, 1]  =  0.333333+0.0im\n  [1, 2]  =  0.333333+0.0im\n  [3, 2]  =  0.333333+0.0im\n  [4, 2]  =  0.333333+0.0im\n  [1, 3]  =  0.333333+0.0im\n  [2, 3]  =  0.333333+0.0im\n  [4, 3]  =  0.333333+0.0im\n  [1, 4]  =  0.333333+0.0im\n  [2, 4]  =  0.333333+0.0im\n  [3, 4]  =  0.333333+0.0im)), 0.0)\n\njulia> penalty(qss)\n0.0\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.check_qwsearch",
    "page": "Quantum search",
    "title": "QuantumWalk.check_qwsearch",
    "category": "Function",
    "text": "check_qwsearch(model, marked, parameters)\n\nChecks whetver combination of model, marked and parameters creates valid quantum search evolution. Note that whetver list of vertices marked are a subset of vertices of graph from model is checked seperately in QWSearch constructor.\n\nDetails concerning implementing check_qwsearch for own models can be found in GitHub pages.\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute-Tuple{QuantumWalk.QWSearch,Real}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute",
    "category": "Method",
    "text": "execute(qss,[ initstate,] runtime[, all, measure])\n\nRun proper execution  of quantum spatial search depending on given keywords. The initial state is generated by initial_state(qss) function if not provided. all and measure keywords defaults to false. For detailed description please see documentation of corresponding function. Note that for all equal to true model in qss needs to be disrete.\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_single-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.QWModelDiscr,Any,Int64}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_single",
    "category": "Method",
    "text": "execute_single(qss,[ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. The initial state is generated by initial_state(qss) function if not provided. runtime needs to be nonnegative. If qss is based on on QWModelDiscr, runtime needs to be Int. QSearchState{S}, where S is the state type, is returned.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_single(qss, 4)\nQuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.438623\n  [3 ]  =  0.438623\n  [4 ]  =  0.438623\n  [5 ]  =  0.104937\n  [7 ]  =  0.254884\n  [8 ]  =  0.254884\n  [9 ]  =  0.104937\n  [10]  =  0.254884\n  [12]  =  0.254884\n  [13]  =  0.104937\n  [14]  =  0.254884\n  [15]  =  0.254884, [0.577169], 4)\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_single_measured-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.QWModelDiscr,Int64}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_single_measured",
    "category": "Method",
    "text": "execute_single_measured(qss, [ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. The initial state is generated by initial_state(qss) function if not provided. runtime needs to be nonnegative. If qss is based on on QWModelDiscr, runtime needs to be Int. Probability measurement distribution is returned.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_single_measured(qss, 4)\n4-element Array{Float64,1}:\n 0.577169\n 0.140944\n 0.140944\n 0.140944\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_all-Union{Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.QWModelDiscr,S,Int64}, Tuple{S}} where S",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_all",
    "category": "Method",
    "text": "execute_all(qss::QSWSearch{<:QWModelDiscr},[ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. runtime needs to be nonnegative. The initial state is generated by initial_state(qss) function if not provided. Quantum walk model needs to be discrete. Returns list of all QSearchState{S} where S is state type including initstate  and last state.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_all(qss, 2)\n3-element Array{QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64},1}:\n QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.288675\n  [3 ]  =  0.288675\n  [4 ]  =  0.288675\n  [5 ]  =  0.288675\n  [7 ]  =  0.288675\n  [8 ]  =  0.288675\n  [9 ]  =  0.288675\n  [10]  =  0.288675\n  [12]  =  0.288675\n  [13]  =  0.288675\n  [14]  =  0.288675\n  [15]  =  0.288675, [0.25], 0)\n QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.481125\n  [3 ]  =  0.481125\n  [4 ]  =  0.481125\n  [5 ]  =  -0.288675\n  [7 ]  =  -0.096225\n  [8 ]  =  -0.096225\n  [9 ]  =  -0.288675\n  [10]  =  -0.096225\n  [12]  =  -0.096225\n  [13]  =  -0.288675\n  [14]  =  -0.096225\n  [15]  =  -0.096225, [0.694444], 1)\n QuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  -0.138992\n  [3 ]  =  -0.138992\n  [4 ]  =  -0.138992\n  [5 ]  =  0.032075\n  [7 ]  =  -0.395592\n  [8 ]  =  -0.395592\n  [9 ]  =  0.032075\n  [10]  =  -0.395592\n  [12]  =  -0.395592\n  [13]  =  0.032075\n  [14]  =  -0.395592\n  [15]  =  -0.395592, [0.0579561], 2)\n\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.execute_all_measured-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.QWModelDiscr,Int64}",
    "page": "Quantum search",
    "title": "QuantumWalk.execute_all_measured",
    "category": "Method",
    "text": "execute_all_measured(qss::QWSearch{<:QWModelDiscr},[ initstate,] runtime)\n\nEvolve initstate acording to QWSearch qss for time runtime. runtime needs to be nonnegative. The initial state is generated by initial_state(qss) function if not provided.Quantum walk model needs to be discrete. As a result return matrix of type Matrix{Float64} for which i-th column  is measurement probability distribution in i-1-th step.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> execute_all_measured(qss, 2)\n4×3 Array{Float64,2}:\n 0.25  0.694444  0.0579561\n 0.25  0.101852  0.314015\n 0.25  0.101852  0.314015\n 0.25  0.101852  0.314015\n\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.maximize_quantum_search",
    "page": "Quantum search",
    "title": "QuantumWalk.maximize_quantum_search",
    "category": "Function",
    "text": "maximize_quantum_search(qss::QWSearch{<:QWModelCont} [, maxtime, tstep])\n\nDetermines optimal runtime for continuous quantum walk models. The time is searched in [0, maxtime] interval, with penalty penalty(qss), which is added. It is recommended for penalty to be nonzero, otherwise time close to 0 is usually returned. Typically small penalty approximately equal to log(n) is enough, but optimal value may depend on the model or graph chosen.\n\nThe optimal time is chosen according to expected runtime, which equals to runtime over probability, which simulates the Bernoulli process based on QWModelCont.\n\ntstep is used for primary grid search to search for determine intervale which is supsected to have small expected runtime. To large value may miss the optimal value, while to small may greatly increase runtime of the algorithm.\n\nmaxtime defaults to graph order n, tstep defaults to sqrt(n)/5. QSearchState is returned by deafult without penalty. Note that in general the probability is not maximal\n\njulia> using QuantumWalk,LightGraphs\n\njulia> qss = QWSearch(CTQW(CompleteGraph(100)), [1], 0.01, 1.);\n\njulia> result = maximize_quantum_search(qss)\nQuantumWalk.QSearchState{Array{Complex{Float64},1},Float64}(Complex{Float64}[0.621142+0.695665im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im  …  0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im, 0.0279736-0.023086im], [0.869767], 12.99636940469214)\n\njulia> expected_runtime(result)\n14.94235723559316\n\njulia> probability(result)\n1-element Array{Float64,1}:\n 0.869767\n\njulia> probability(execute_single(qss, pi*sqrt(100)/2))\n1-element Array{Float64,1}:\n 1.0\n\n\n\nmaximize_quantum_search(qss::QWSearch{<:QWModelDiscr} [, runtime, mode])\n\nDetermines optimal runtime for continuous quantum walk models. The time is searched in [0, runtime] interval, with penalty penalty(qss), which is added. It is recommended for penalty to be nonzero, otherwise time close 0 is returned. Typically small penalty approximately equal to log(n) is enough, but optimal value may depend on the model or graph chosen.\n\nThe optimal time depende on chosen mode:\n\n:firstmaxprob stops when probability start to decrease,\n:firstmaxeff stops whene expected runtime start to increase,\n:maxtimeeff chooses exhaustively the time from [0, runtime] with smallest expected time,\n:maxtimeprob chooses exhaustively the time from [0, runtime] with maximal success probability,\n:maxeff (default) finds optimal time with smallest expected time, usually faster\n\nthan :maxtimefff.\n\nNote last three modes always returns optimal time within the interval.\n\nmaxtime defaults to graph order n, mode defaults to :maxeff. QSearchState is returned by deafult without penalty.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(200)), [1], 1);\n\njulia> result = maximize_quantum_search(qss);\n\njulia> runtime(result)\n7\n\njulia> probability(result)\n1-element Array{Float64,1}:\n 0.500016\n\njulia> result = maximize_quantum_search(qss, 100, :maxtimeprob);\n\njulia> runtime(result)\n40\n\njulia> probability(result)\n1-element Array{Float64,1}:\n 0.550938\n\n\n\n"
},

{
    "location": "quantum_search.html#Types-and-its-function-1",
    "page": "Quantum search",
    "title": "Types and its function",
    "category": "section",
    "text": "QWSearch\nmarked\npenaltycheck_qwsearchexecute(::QWSearch, ::Real)\nexecute_single(::QWSearch{<:QWModelDiscr}, ::Any, ::Int)\nexecute_single_measured(::QWSearch{<:QWModelDiscr}, ::Int)\nexecute_all(::QWSearch{<:QWModelDiscr}, ::S, ::Int) where S\nexecute_all_measured(::QWSearch{<:QWModelDiscr}, ::Int)maximize_quantum_search"
},

{
    "location": "quantum_search.html#QuantumWalk.QSearchState",
    "page": "Quantum search",
    "title": "QuantumWalk.QSearchState",
    "category": "Type",
    "text": "QSearchState(state, probability, runtime)\nQSearchState(qss, state, runtime)\n\nCreates container which consists of state, success probability probability and running time runtime. Validity of probability and runtime is not checked.\n\nIn second case state is measured according to qss is made.\n\njulia?> 2+2\n5\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = QSearchState(qss, initial_state(qss), 0)\nQuantumWalk.QSearchState{SparseVector{Float64,Int64},Int64}(  [2 ]  =  0.288675\n  [3 ]  =  0.288675\n  [4 ]  =  0.288675\n  [5 ]  =  0.288675\n  [7 ]  =  0.288675\n  [8 ]  =  0.288675\n  [9 ]  =  0.288675\n  [10]  =  0.288675\n  [12]  =  0.288675\n  [13]  =  0.288675\n  [14]  =  0.288675\n  [15]  =  0.288675, [0.25], 0)\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.state",
    "page": "Quantum search",
    "title": "QuantumWalk.state",
    "category": "Function",
    "text": "state(qsearchstate)\n\nReturns the state of qsearchstate.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = QSearchState(qss, initial_state(qss), 0);\n\njulia> state(result)\n16-element SparseVector{Float64,Int64} with 12 stored entries:\n  [2 ]  =  0.288675\n  [3 ]  =  0.288675\n  [4 ]  =  0.288675\n  [5 ]  =  0.288675\n  [7 ]  =  0.288675\n  [8 ]  =  0.288675\n  [9 ]  =  0.288675\n  [10]  =  0.288675\n  [12]  =  0.288675\n  [13]  =  0.288675\n  [14]  =  0.288675\n  [15]  =  0.288675\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.probability",
    "page": "Quantum search",
    "title": "QuantumWalk.probability",
    "category": "Function",
    "text": "probability(qsearchstate)\n\nReturns the list of probabilities of finding marked vertices.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = QSearchState(qss, initial_state(qss), 0);\n\njulia> probability(result)\n1-element Array{Float64,1}:\n 0.25\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.runtime",
    "page": "Quantum search",
    "title": "QuantumWalk.runtime",
    "category": "Function",
    "text": "runtime(qsearchstate)\n\nReturns the time for which the state was calulated.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = QSearchState(qss, initial_state(qss), 0);\n\njulia> runtime(result)\n0\n\n\n\n\n"
},

{
    "location": "quantum_search.html#QuantumWalk.expected_runtime",
    "page": "Quantum search",
    "title": "QuantumWalk.expected_runtime",
    "category": "Function",
    "text": "expected_runtime(runtime, probability)\nexpected_runtime(state)\n\nReturns the expected runtime needed for quantum walk, considering it as Bernoulli process. It equals to runtime/probability. In the case of state provided the measurement is made.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> result = execute(qss, 4);\n\njulia> expected_runtime(result)\n6.930377097077988\n\njulia> expected_runtime(runtime(result), sum(probability(result)))\n6.930377097077988\n\n\n\n"
},

{
    "location": "quantum_search.html#QSearchState-1",
    "page": "Quantum search",
    "title": "QSearchState",
    "category": "section",
    "text": "QSearchState\nstate\nprobability\nruntimeexpected_runtime"
},

{
    "location": "ctqw.html#",
    "page": "CTQW model",
    "title": "CTQW model",
    "category": "page",
    "text": ""
},

{
    "location": "ctqw.html#Continuous-Time-Quantum-Walk-1",
    "page": "CTQW model",
    "title": "Continuous-Time Quantum Walk",
    "category": "section",
    "text": "Exemplary implementation of continuous quantum walk model. The model is defined for arbitrary undirected graph. Hamiltonian is chosen to be adjacency matrix, and the evolution is made on the pure system of size equal to graph order. The definition can be found in Spatial search by quantum walk, written by Childs and Goldstone."
},

{
    "location": "ctqw.html#Full-docs-1",
    "page": "CTQW model",
    "title": "Full docs",
    "category": "section",
    "text": ""
},

{
    "location": "ctqw.html#QuantumWalk.AbstractCTQW",
    "page": "CTQW model",
    "title": "QuantumWalk.AbstractCTQW",
    "category": "Type",
    "text": "AbstractCTQW\n\nAbstract CTQW model. By default evolve according to Schrödinger equation and performs measurmenet by taking square of absolute values of its elements. Default representation of AbstractCTQW is CTQW.\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.CTQW",
    "page": "CTQW model",
    "title": "QuantumWalk.CTQW",
    "category": "Type",
    "text": "CTQW(graph[, matrix])\n\nDefault representation of AbstractCTQW. graph needs to be of type Graph from LightGraphs module, matrix needs to be :adjacency or :laplacian and defaults to :adjacency.\n\n\n\n"
},

{
    "location": "ctqw.html#Model-definition-1",
    "page": "CTQW model",
    "title": "Model definition",
    "category": "section",
    "text": "AbstractCTQW\nCTQW"
},

{
    "location": "ctqw.html#QuantumWalk.evolve-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.AbstractCTQW,Array{#s15,1} where #s15<:Number,Real}",
    "page": "CTQW model",
    "title": "QuantumWalk.evolve",
    "category": "Method",
    "text": "evolve(qwd, state, runtime)\n\nReturnes new state creates by evolving state by qwd.parameters[:hamiltonian] for time runtime according to Schrödinger equation.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1]);\n\njulia> evolve(qss, initial_state(qss), 1.)\n4-element Array{Complex{Float64},1}:\n -0.128942+0.67431im\n  0.219272+0.357976im\n  0.219272+0.357976im\n  0.219272+0.357976im\n\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.measure-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.AbstractCTQW,Any}",
    "page": "CTQW model",
    "title": "QuantumWalk.measure",
    "category": "Method",
    "text": "measure(qwd::QWDynamics{<:AbstractCTQW}, state [, vertices])\n\nReturns the probability of measuring each vertex from vertices from state according to AbstractCTQW model. If vertices is not provided, full measurement is made. For AbstractCTQW model measurement is done by taking square of absolute value of all elements of state.\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1]);\n\njulia> measure(qss, [sqrt(0.2), sqrt(0.3), sqrt(0.5)])\n3-element Array{Float64,1}:\n 0.2\n 0.3\n 0.5\n\n julia> measure(qss, [sqrt(0.2), sqrt(0.3), sqrt(0.5)], [2, 3])\n 2-element Array{Float64,1}:\n  0.3\n  0.5\n\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.matrix-Tuple{QuantumWalk.AbstractCTQW}",
    "page": "CTQW model",
    "title": "QuantumWalk.matrix",
    "category": "Method",
    "text": "matrix(ctqw::AbstractCTQW)\n\nReturns the matrix symbol defining matrix graph used.\n\njulia> matrix(CTQW(CompleteGraph(4)))\n:adjacency\n\njulia> matrix(CTQW(CompleteGraph(4), :laplacian))\n:laplacian\n\n\n\n"
},

{
    "location": "ctqw.html#General-model-functions-1",
    "page": "CTQW model",
    "title": "General model functions",
    "category": "section",
    "text": "evolve(::QWDynamics{<:AbstractCTQW}, ::Vector{<:Number}, ::Real)\nmeasure(::QWDynamics{<:AbstractCTQW}, ::Any)\nmatrix(::AbstractCTQW)"
},

{
    "location": "ctqw.html#QuantumWalk.QWSearch-Union{Tuple{T}, Tuple{Type{T},QuantumWalk.AbstractCTQW,Array{Int64,N} where N,T,Real}, Tuple{Type{T},QuantumWalk.AbstractCTQW,Array{Int64,N} where N,T}} where T<:Number",
    "page": "CTQW model",
    "title": "QuantumWalk.QWSearch",
    "category": "Method",
    "text": "QWSearch([type, ]ctqw::AbstractCTQW, marked [, jumpingrate, penalty])\n\nCreates QWSearch according to AbstractCTQW model. By default type equals Complex128, jumpingrate equals largest eigenvalue of adjacency matrix of graph if matrix(CTQW) outputs :adjacency and error otherwise, and penalty equals 0. By default hamiltonian is SparseMatrixCSC.\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.initial_state-Tuple{QuantumWalk.QWSearch{#s16,W} where W<:Real where #s16<:QuantumWalk.AbstractCTQW}",
    "page": "CTQW model",
    "title": "QuantumWalk.initial_state",
    "category": "Method",
    "text": "initial_state(qss::QWSearch{AbstractCTQW})\n\nReturns equal superposition of size size and type of qss.parameters[:hamiltonian].\n\njulia> qss = QWSearch(CTQW(CompleteGraph(4)), [1]);\n\njulia> initial_state(qss)\n4-element Array{Complex{Float64},1}:\n 0.5+0.0im\n 0.5+0.0im\n 0.5+0.0im\n 0.5+0.0im\n\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.check_qwsearch-Tuple{QuantumWalk.AbstractCTQW,Array{Int64,N} where N,Dict{Symbol,V} where V}",
    "page": "CTQW model",
    "title": "QuantumWalk.check_qwsearch",
    "category": "Method",
    "text": "check_qwsearch(ctqw::AbstractCTQW, marked, parameters)\n\nChecks whetver combination of ctqw, marked and parameters produces valid QWSearch object. It checks where parameters consists of key :hamiltonian with corresponding value being SparseMatrixCSC or Matrix. Furthermore the hamiltonian needs to be square of size equals to graph(ctqw) order.\n\n\n\n"
},

{
    "location": "ctqw.html#QWSearch-documentation-1",
    "page": "CTQW model",
    "title": "QWSearch documentation",
    "category": "section",
    "text": "QWSearch(::Type{T}, ::AbstractCTQW, ::Array{Int}, ::T, ::Real = 0.) where T<:Number\ninitial_state(::QWSearch{<:AbstractCTQW})\ncheck_qwsearch(::AbstractCTQW, ::Array{Int}, ::Dict{Symbol})"
},

{
    "location": "ctqw.html#QuantumWalk.QWEvolution-Union{Tuple{Type{U},QuantumWalk.AbstractCTQW}, Tuple{U}} where U<:Number",
    "page": "CTQW model",
    "title": "QuantumWalk.QWEvolution",
    "category": "Method",
    "text": "QWEvolution([type, ]ctqw::AbstractCTQW)\n\nCreates QWEvolution according to AbstractCTQW model. By default type equals Complex128. By default constructed hamiltonian is SparseMatrixCSC.\n\n\n\n"
},

{
    "location": "ctqw.html#QuantumWalk.check_qwevolution-Tuple{QuantumWalk.AbstractCTQW,Dict{Symbol,V} where V}",
    "page": "CTQW model",
    "title": "QuantumWalk.check_qwevolution",
    "category": "Method",
    "text": "check_qwevolution(ctqw::AbstractCTQW, parameters)\n\nChecks whetver combination of ctqw and parameters produces valid QWSearch object. It checks where parameters consists of key :hamiltonian with corresponding value being SparseMatrixCSC or Matrix. Furthermore the hamiltonian needs to be square of size equals to graph(ctqw) order.\n\n\n\n"
},

{
    "location": "ctqw.html#QWEvolution-documentation-1",
    "page": "CTQW model",
    "title": "QWEvolution documentation",
    "category": "section",
    "text": "QWEvolution(::Type{U}, ::AbstractCTQW) where U<:Number\ncheck_qwevolution(::AbstractCTQW, ::Dict{Symbol})"
},

{
    "location": "szegedy.html#",
    "page": "Szegedy model",
    "title": "Szegedy model",
    "category": "page",
    "text": "Depth = 4"
},

{
    "location": "szegedy.html#Szegedy-Quantum-Walk-1",
    "page": "Szegedy model",
    "title": "Szegedy Quantum Walk",
    "category": "section",
    "text": ""
},

{
    "location": "szegedy.html#Full-docs-1",
    "page": "Szegedy model",
    "title": "Full docs",
    "category": "section",
    "text": ""
},

{
    "location": "szegedy.html#QuantumWalk.AbstractSzegedy",
    "page": "Szegedy model",
    "title": "QuantumWalk.AbstractSzegedy",
    "category": "Type",
    "text": "AbstractSzegedy\n\nAbstract Szegedy model. Description of the default parameter can be found in https://arxiv.org/abs/1611.02238, where two oracle operator case is chosen. Default representation of AbstractSzegedy is Szegedy.\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.Szegedy",
    "page": "Szegedy model",
    "title": "QuantumWalk.Szegedy",
    "category": "Type",
    "text": "Szegedy(graph[, stochastic, checkstochastic])\n\nDefault representation of AbstractSzegedy. Parameter graph needs to be a  subtype of AbstractGraph from LightGraphs module, and parameter stochastic  needs to be a Real column stochastic matrix. Flag checkstochastic decides  about checking the stochastic properties.\n\nMatrix stochastic defaults to the uniform walk operator, and  checkstochastic deafults to false in case of default stochastic. If  matrix stochastic is provided by the user, the default value of stochastic  is true.\n\nMatrix stochastic is changed into sqrtstochastic by taking element-wise  square root.\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.sqrtstochastic",
    "page": "Szegedy model",
    "title": "QuantumWalk.sqrtstochastic",
    "category": "Function",
    "text": "sqrtstochastic(szegedy)\n\nReturn the sqrtstochastic element of szegedy. After element-wise squaring a column-stochastic matrix is obtained.\n\njulia> szegedy = Szegedy(CompleteGraph(4));\n\njulia> sqrtstochastic(szegedy)\n4×4 SparseMatrixCSC{Float64,Int64} with 12 stored entries:\n  [2, 1]  =  0.57735\n  [3, 1]  =  0.57735\n  [4, 1]  =  0.57735\n  [1, 2]  =  0.57735\n  [3, 2]  =  0.57735\n  [4, 2]  =  0.57735\n  [1, 3]  =  0.57735\n  [2, 3]  =  0.57735\n  [4, 3]  =  0.57735\n  [1, 4]  =  0.57735\n  [2, 4]  =  0.57735\n  [3, 4]  =  0.57735\n\njulia> full(sqrtstochastic(szegedy).^2)\n4×4 Array{Float64,2}:\n 0.0       0.333333  0.333333  0.333333\n 0.333333  0.0       0.333333  0.333333\n 0.333333  0.333333  0.0       0.333333\n 0.333333  0.333333  0.333333  0.0\n\n\n\n"
},

{
    "location": "szegedy.html#Model-definition-1",
    "page": "Szegedy model",
    "title": "Model definition",
    "category": "section",
    "text": "AbstractSzegedy\nSzegedy\nsqrtstochastic"
},

{
    "location": "szegedy.html#QuantumWalk.evolve-Union{Tuple{QuantumWalk.QWDynamics{QuantumWalk.Szegedy{#s16,T} where #s16},SparseVector{T,Ti} where Ti<:Integer}, Tuple{T}} where T<:Number",
    "page": "Szegedy model",
    "title": "QuantumWalk.evolve",
    "category": "Method",
    "text": "evolve(qwe::QWSearch{AbstractSzegedy}, state)\n\nMultiplies state be each operator from operators from quatnum walk evolution qwe. Elements of operators and state should be of the same type.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> evolve(qss, initial_state(qss))\n16-element SparseVector{Float64,Int64} with 12 stored entries:\n  [2 ]  =  0.481125\n  [3 ]  =  0.481125\n  [4 ]  =  0.481125\n  [5 ]  =  -0.288675\n  [7 ]  =  -0.096225\n  [8 ]  =  -0.096225\n  [9 ]  =  -0.288675\n  [10]  =  -0.096225\n  [12]  =  -0.096225\n  [13]  =  -0.288675\n  [14]  =  -0.096225\n  [15]  =  -0.096225\n\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.measure-Tuple{QuantumWalk.QWDynamics{#s16} where #s16<:QuantumWalk.AbstractSzegedy,SparseVector{#s15,Ti} where Ti<:Integer where #s15<:Number}",
    "page": "Szegedy model",
    "title": "QuantumWalk.measure",
    "category": "Method",
    "text": "measure(qwd::AbstractSzegedy, state[, vertices])\n\nPerformes a measurement on state on vertices. vertices defaults to list of all vertices. It is defined as the measurement of partially traced on second system state https://arxiv.org/abs/1611.02238.\n\njulia> qss = QWSearch(Szegedy(CompleteGraph(4)), [1]);\n\njulia> state = evolve(qss, initial_state(qss));\n\njulia> measure(qss, state)\n4-element Array{Float64,1}:\n 0.694444\n 0.101852\n 0.101852\n 0.101852\n\njulia> measure(qss, state, [1,3])\n2-element Array{Float64,1}:\n 0.694444\n 0.101852\n\n\n\n\n"
},

{
    "location": "szegedy.html#General-model-functions-1",
    "page": "Szegedy model",
    "title": "General model functions",
    "category": "section",
    "text": "evolve(::QWDynamics{Szegedy{<:Any,T}}, ::SparseVector{T}) where T<:Number\nmeasure(::QWDynamics{<:AbstractSzegedy}, ::SparseVector{<:Number})"
},

{
    "location": "szegedy.html#QuantumWalk.QWSearch-Tuple{QuantumWalk.AbstractSzegedy,Array{Int64,N} where N,Real}",
    "page": "Szegedy model",
    "title": "QuantumWalk.QWSearch",
    "category": "Method",
    "text": "QWSearch(szegedy::AbstractSzegedy, marked [, penalty])\n\nCreates QWSearch according to AbstractSzegedy model. By default parameter penalty is set to 0. Evolution operators are constructed according to the definition from https://arxiv.org/abs/1611.02238.\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.check_qwsearch-Tuple{QuantumWalk.AbstractSzegedy,Array{Int64,N} where N,Dict{Symbol,V} where V}",
    "page": "Szegedy model",
    "title": "QuantumWalk.check_qwsearch",
    "category": "Method",
    "text": "check_qwsearch(szegedy::AbstractSzegedy, marked, parameters)\n\nCheck whetver combination of szegedy, marked and parameters produces valid QWSearch object. It checks where parameters consists of key :operators with corresponding value being list of SparseMatrixCSC. Furthermore operators needs to be square of size equals to square of graph(szegedy). order.\n\n\n\n"
},

{
    "location": "szegedy.html#Quantum-search-constructor-1",
    "page": "Szegedy model",
    "title": "Quantum search constructor",
    "category": "section",
    "text": "QWSearch(::AbstractSzegedy, ::Array{Int}, ::Real)\ncheck_qwsearch(::AbstractSzegedy, ::Array{Int}, ::Dict{Symbol})"
},

{
    "location": "szegedy.html#QuantumWalk.QWEvolution-Tuple{QuantumWalk.AbstractSzegedy}",
    "page": "Szegedy model",
    "title": "QuantumWalk.QWEvolution",
    "category": "Method",
    "text": "QWEvolution(szegedy::AbstractSzegedy)\n\nCreate QWEvolution according to AbstractSzegedy model. By default, the constructed operator is of type SparseMatrixCSC.\n\n\n\n"
},

{
    "location": "szegedy.html#QuantumWalk.check_qwevolution-Tuple{QuantumWalk.AbstractSzegedy,Dict{Symbol,V} where V}",
    "page": "Szegedy model",
    "title": "QuantumWalk.check_qwevolution",
    "category": "Method",
    "text": "check_qwevolution(szegedy::AbstractSzegedy, marked, parameters)\n\nCheck whetver combination of szegedy, marked and parameters produces a valid QWEvolution object. It checks where parameters consists of key :operators with corresponding value being a list of SparseMatrixCSC objects. Furthermore operators need to be square of size equals to square of the order of graph(szegedy).\n\n\n\n"
},

{
    "location": "szegedy.html#Quantum-walk-constructor-1",
    "page": "Szegedy model",
    "title": "Quantum walk constructor",
    "category": "section",
    "text": "QWEvolution(::AbstractSzegedy)\ncheck_qwevolution(::AbstractSzegedy, ::Dict{Symbol})"
},

{
    "location": "new_model.html#QuantumWalk.initial_state",
    "page": "New model",
    "title": "QuantumWalk.initial_state",
    "category": "Function",
    "text": "initial_state(qss)\n\nGenerates initial state for QWSearch qss. The type and value strongly depends on model of qss. For concrete model description please type ?initial_state(QWSearch{model}), for example for CTQW write ?initial_state(QWSearch{CTQW}).\n\nDetails concerning implementing initial_state for own models can be found in GitHub pages.\n\n\n\n"
},

{
    "location": "new_model.html#QuantumWalk.evolve",
    "page": "New model",
    "title": "QuantumWalk.evolve",
    "category": "Function",
    "text": "evolve(qwevolution{<:QWModelDiscr}, state)\nevolve(qwevolution{<:QWModelCont}, state, time)\n\nEvolve state according to qwevolution. time should be provided if model is continuous, otherwise one-step evolution should be performed. Type returned should be the same as type of state. The behaviour strongly depends on model of qwevolution. For concrete model description please type ?evolve(qwevolution{model}), for example for CTQW and QWSearch write ?evolve(QWSearch{CTQW}).\n\nDetails concerning implementing evolve for own models can be found in GitHub pages.\n\n\n\n"
},

{
    "location": "new_model.html#QuantumWalk.measure",
    "page": "New model",
    "title": "QuantumWalk.measure",
    "category": "Function",
    "text": "measure(qwevolution, state[, vertices])\n\nMeasure state according to model from quantum walk evolution qwevolution. If vertices is provided, probabilities of given vertices should be provided. Otherwise full probability distribution should be provided. Output should be always of type Array{Float64}. The behaviour strongly depends on model of qwe. For concrete model and qwevolution description please type ?measure(qwevolution{model}), for example for CTQW and QWSearch write ?measure(QWSearch{CTQW}).\n\nDetails concerning implementing measure for own models can be found in GitHub pages.\n\n\n\n"
},

{
    "location": "new_model.html#",
    "page": "New model",
    "title": "New model",
    "category": "page",
    "text": "initial_state\nevolve\nmeasure"
},

{
    "location": "new_dynamics.html#",
    "page": "New dynamics",
    "title": "New dynamics",
    "category": "page",
    "text": ""
},

{
    "location": "license.html#",
    "page": "Licence",
    "title": "Licence",
    "category": "page",
    "text": "MIT LicenseCopyright (c) 2017 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
},

]}
