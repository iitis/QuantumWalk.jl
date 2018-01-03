var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Basics",
    "title": "Basics",
    "category": "page",
    "text": "Welcom to QSpatialSearch.jl package."
},

{
    "location": "type_hierarchy.html#",
    "page": "Quantum walk evolution types",
    "title": "Quantum walk evolution types",
    "category": "page",
    "text": ""
},

{
    "location": "quantum_search.html#",
    "page": "Quantum search",
    "title": "Quantum search",
    "category": "page",
    "text": ""
},

{
    "location": "quantum_walk.html#",
    "page": "Quantum walk simulator",
    "title": "Quantum walk simulator",
    "category": "page",
    "text": ""
},

{
    "location": "ctqw.html#",
    "page": "CTQW model",
    "title": "CTQW model",
    "category": "page",
    "text": "Depth = 4"
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
    "location": "ctqw.html#QSpatialSearch.initial_state-Tuple{QSpatialSearch.QSearch{#s7,W} where W<:Real where #s7<:QSpatialSearch.AbstractCTQW}",
    "page": "CTQW model",
    "title": "QSpatialSearch.initial_state",
    "category": "Method",
    "text": "initial_state(qss::QSearch{AbstractCTQW})\n\nReturns equal superposition of size size and type of qss.parameters[:hamiltonian].\n\njulia> qss = QSearch(CTQW(CompleteGraph(4)), [1]);\n\njulia> initial_state(qss)\n4-element Array{Complex{Float64},1}:\n 0.5+0.0im\n 0.5+0.0im\n 0.5+0.0im\n 0.5+0.0im\n\n\n\n\n"
},

{
    "location": "ctqw.html#QSpatialSearch.evolve-Tuple{QSpatialSearch.QWalkEvolution{#s7} where #s7<:QSpatialSearch.AbstractCTQW,Array{#s6,1} where #s6<:Number,Real}",
    "page": "CTQW model",
    "title": "QSpatialSearch.evolve",
    "category": "Method",
    "text": "evolve(qss, state, runtime)\n\nReturnes new state creates by evolving state by qss.parameters[:hamiltonian] for time runtime according to Schrödinger equation.\n\njulia> qss = QSearch(CTQW(CompleteGraph(4)), [1]);\n\njulia> evolve(qss, initial_state(qss), 1.)\n4-element Array{Complex{Float64},1}:\n -0.128942+0.67431im\n  0.219272+0.357976im\n  0.219272+0.357976im\n  0.219272+0.357976im\n\n\n\n\n"
},

{
    "location": "ctqw.html#QSpatialSearch.measure-Tuple{QSpatialSearch.QWalkEvolution{#s7} where #s7<:QSpatialSearch.AbstractCTQW,Any}",
    "page": "CTQW model",
    "title": "QSpatialSearch.measure",
    "category": "Method",
    "text": "measure(::QWalkEvolution{<:AbstractCTQW}, state [, vertices])\n\nReturns the probability of measuring each vertex from vertices from state according to AbstractCTQW model. If vertices is not provided, full measurement is made. For AbstractCTQW model measurement is done by taking square of absolute value of all elements of state.\n\njulia> qss = QSearch(CTQW(CompleteGraph(4)), [1]);\n\njulia> measure(qss, [sqrt(0.2), sqrt(0.3), sqrt(0.5)])\n3-element Array{Float64,1}:\n 0.2\n 0.3\n 0.5\n\n julia> measure(qss, [sqrt(0.2), sqrt(0.3), sqrt(0.5)], [2, 3])\n 2-element Array{Float64,1}:\n  0.3\n  0.5\n\n\n\n\n"
},

{
    "location": "ctqw.html#QSpatialSearch.matrix-Tuple{QSpatialSearch.AbstractCTQW}",
    "page": "CTQW model",
    "title": "QSpatialSearch.matrix",
    "category": "Method",
    "text": "matrix(ctqw::AbstractCTQW)\n\nReturns the matrix symbol defining matrix graph used.\n\njulia> matrix(CTQW(CompleteGraph(4)))\n:adjacency\n\njulia> matrix(CTQW(CompleteGraph(4), :laplacian))\n:laplacian\n\n\n\n"
},

{
    "location": "ctqw.html#Model-functions-1",
    "page": "CTQW model",
    "title": "Model functions",
    "category": "section",
    "text": "initial_state(::QSearch{<:AbstractCTQW})\nevolve(::QWalkEvolution{<:AbstractCTQW}, ::Vector{<:Number}, ::Real)\nmeasure(::QWalkEvolution{<:AbstractCTQW}, ::Any)\nmatrix(::AbstractCTQW)"
},

{
    "location": "ctqw.html#QSpatialSearch.QSearch-Union{Tuple{T}, Tuple{Type{T},QSpatialSearch.AbstractCTQW,Array{Int64,N} where N,T,Real}, Tuple{Type{T},QSpatialSearch.AbstractCTQW,Array{Int64,N} where N,T}} where T<:Number",
    "page": "CTQW model",
    "title": "QSpatialSearch.QSearch",
    "category": "Method",
    "text": "QSearch([type, ]ctqw::AbstractCTQW, marked [, jumpingrate, penalty])\n\nCreates QSearch according to AbstractCTQW model. By default type equals Complex128, jumpingrate equals largest eigenvalue of adjacency matrix of graph if matrix(CTQW) outputs :adjacency and error otherwise, and penalty equals 0. By default hamiltonian is SparseMatrixCSC.\n\n\n\n"
},

{
    "location": "ctqw.html#QSpatialSearch.check_qss",
    "page": "CTQW model",
    "title": "QSpatialSearch.check_qss",
    "category": "Function",
    "text": "check_qss(qwalk, marked, parameters)\n\nChecks whetver combination of qwalk, marked and parameters creates valid quantum search evolution. Note that whetver list of vertices marked are a subset of vertices of graph from qwalk is checked seperately in QSearch constructor.\n\nDetails concerning implementing check_qss for own models can be found in GitHub pages.\n\n\n\n"
},

{
    "location": "ctqw.html#Quantum-search-constructor-1",
    "page": "CTQW model",
    "title": "Quantum search constructor",
    "category": "section",
    "text": "QSearch(::Type{T}, ::AbstractCTQW, ::Array{Int}, ::T, ::Real = 0.) where T<:Number\ncheck_qss"
},

{
    "location": "ctqw.html#QSpatialSearch.QWalkSimulator",
    "page": "CTQW model",
    "title": "QSpatialSearch.QWalkSimulator",
    "category": "Type",
    "text": "QWalkSimulator\n\n\n\n"
},

{
    "location": "ctqw.html#QSpatialSearch.check_qwalksimulator",
    "page": "CTQW model",
    "title": "QSpatialSearch.check_qwalksimulator",
    "category": "Function",
    "text": "check_qwalksimulator(qwalk, parameters)\n\nChecks whetver combination of qwalk and parameters creates valid quantum walk simulator.\n\nDetails concerning implementing check_qws for own models can be found in GitHub pages.\n\n\n\n"
},

{
    "location": "ctqw.html#Quantum-walk-constructor-1",
    "page": "CTQW model",
    "title": "Quantum walk constructor",
    "category": "section",
    "text": "QWalkSimulator\ncheck_qwalksimulator"
},

{
    "location": "szegedy.html#",
    "page": "Szegedy model",
    "title": "Szegedy model",
    "category": "page",
    "text": ""
},

{
    "location": "own_model.html#",
    "page": "How to make your own model?",
    "title": "How to make your own model?",
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

{
    "location": "citing.html#",
    "page": "Citing",
    "title": "Citing",
    "category": "page",
    "text": ""
},

{
    "location": "contributing.html#",
    "page": "Contributing",
    "title": "Contributing",
    "category": "page",
    "text": ""
},

]}
