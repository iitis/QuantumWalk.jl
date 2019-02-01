@testset "Stochastic utils" begin
    @testset "Generalized neighbor function" begin
      g = DiGraph(3)
      @test QuantumWalk.outneighbors_looped(g, 3) == [3]

      add_edge!(g, 1, 2)
      add_edge!(g, 1, 3)

      @test QuantumWalk.outneighbors_looped(g, 1) == [2, 3]
      @test QuantumWalk.outneighbors_looped(g, 3) == [3]

      @test QuantumWalk.outneighbors_looped(CompleteGraph(3), 3) == [1, 2]
      @test QuantumWalk.outneighbors_looped(CompleteDiGraph(3), 3) == [1, 2]

      @test_throws BoundsError QuantumWalk.outneighbors_looped(g, 0)
      @test_throws BoundsError QuantumWalk.outneighbors_looped(g, 4)
    end

    @testset "Graph stochastic matrix checker" begin
        g = smallgraph(:bull)

        @test QuantumWalk.graphstochasticcheck(g, QuantumWalk.uniform_stochastic(g)) == nothing

        g = DiGraph(3)
        add_edge!(g, 1, 3)

        @test QuantumWalk.graphstochasticcheck(g, QuantumWalk.uniform_stochastic(g)) == nothing

     # negative cases
     g = smallgraph(:bull)
     @test_throws AssertionError QuantumWalk.graphstochasticcheck(g, adjacency_matrix(g))
     @test_throws AssertionError QuantumWalk.graphstochasticcheck(CompleteGraph(nv(g)+1), QuantumWalk.uniform_stochastic(g))
     @test_throws AssertionError QuantumWalk.graphstochasticcheck(DiGraph(nv(g)), adjacency_matrix(g))

     g = DiGraph(3)
     add_edge!(g, 1, 2)
     add_edge!(g, 1, 3)

     @test_throws AssertionError QuantumWalk.graphstochasticcheck(g, sparse([0 0 0; -1 1 0; 2 0 1]))
     #dense not allowed
     @test_throws MethodError QuantumWalk.graphstochasticcheck(g, Matrix(QuantumWalk.uniform_stochastic(g)))

     #
     g = smallgraph(:bull)
     add_vertex!(g)
     @test QuantumWalk.uniform_stochastic(g, 6) == SparseVector([0., 0., 0., 0., 0., 1.])
    end

    @testset "Default stochastic matrix" begin
      g = smallgraph(:bull)
      result = [0.0  1. /3  1. /3  0.0  0.0;
                0.5  0.0   1. /3  1.0  0.0;
                0.5  1. /3  0.0   0.0  1.0;
                0.0  1. /3  0.0   0.0  0.0;
                0.0  0.0   1. /3  0.0  0.0]

      @test isapprox(QuantumWalk.uniform_stochastic(g), sparse(result), atol=1e-5)

      g = DiGraph(3)
      add_edge!(g, 1, 3)
      @test isapprox(QuantumWalk.uniform_stochastic(g), [0 0 0; 0 1 0; 1 0 1], atol=1e-5)
    end
end
