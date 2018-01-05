@testset "Szegedy model test" begin
  @testset "Generalized neighbor function" begin
    g = DiGraph(3)
    @test QuantumWalk.out_neighbors_looped(g, 3) == [3]

    add_edge!(g, 1, 2)
    add_edge!(g, 1, 3)

    @test QuantumWalk.out_neighbors_looped(g, 1) == [2, 3]
    @test QuantumWalk.out_neighbors_looped(g, 3) == [3]

    @test QuantumWalk.out_neighbors_looped(CompleteGraph(3), 3) == [1, 2]
    @test QuantumWalk.out_neighbors_looped(CompleteDiGraph(3), 3) == [1, 2]

    @test_throws BoundsError QuantumWalk.out_neighbors_looped(g, 0)
    @test_throws BoundsError QuantumWalk.out_neighbors_looped(g, 4)
  end

  @testset "Graph stochastic matrix checker" begin
  g = smallgraph(:bull)

  @test QuantumWalk.graphstochasticcheck(g, QuantumWalk.default_stochastic(g)) == nothing

  g = DiGraph(3)
  add_edge!(g, 1, 3)

  @test QuantumWalk.graphstochasticcheck(g, QuantumWalk.default_stochastic(g)) == nothing

   # negative cases
   g = smallgraph(:bull)
   @test_throws AssertionError QuantumWalk.graphstochasticcheck(g, adjacency_matrix(g))
   @test_throws AssertionError QuantumWalk.graphstochasticcheck(CompleteGraph(nv(g)+1), QuantumWalk.default_stochastic(g))
   @test_throws AssertionError QuantumWalk.graphstochasticcheck(DiGraph(nv(g)), adjacency_matrix(g))

   g = DiGraph(3)
   add_edge!(g, 1, 2)
   add_edge!(g, 1, 3)

   @test_throws AssertionError QuantumWalk.graphstochasticcheck(g, sparse([0 0 0; -1 1 0; 2 0 1]))
   #dense not allowed
   @test_throws MethodError QuantumWalk.graphstochasticcheck(g, full(QuantumWalk.default_stochastic(g)))
  end

  @testset "Default stochastic matrix" begin
    g = smallgraph(:bull)
    result = [0.0  1./3  1./3  0.0  0.0;
              0.5  0.0   1./3  1.0  0.0;
              0.5  1./3  0.0   0.0  1.0;
              0.0  1./3  0.0   0.0  0.0;
              0.0  0.0   1./3  0.0  0.0]

    @test isapprox(QuantumWalk.default_stochastic(g), sparse(result), atol=1e-5)

    g = DiGraph(3)
    add_edge!(g, 1, 3)
    @test isapprox(QuantumWalk.default_stochastic(g), [0 0 0; 0 1 0; 1 0 1], atol=1e-5)
  end

  @testset "Szegedy walk operators" begin
    g = smallgraph(:bull)

    r1, r2 = QuantumWalk.szegedywalkoperators(Szegedy(g))
    @test isapprox(norm(r1*r1'-eye(r1), Inf), 0, atol=1e-8)
    @test isapprox(norm(r2*r2'-eye(r2), Inf), 0, atol=1e-8)

    q1, q2 = QuantumWalk.szegedyoracleoperators(Szegedy(g), [2, 3])

    @test all(typeof(m) == SparseMatrixCSC{Float64,Int} for m = [r1, r2, q1, q2])

    @test isapprox(norm(q1*q1'-eye(q1), Inf), 0, atol=1e-8)
    @test isapprox(norm(q2*q2'-eye(q2), Inf), 0, atol=1e-8)
    @test isdiag(q1)
    @test isdiag(q2)
  end

  @testset "Szegedy initial state and measurement" begin
    g = smallgraph(:bull)
    n = nv(g)
    qss = QWSearch(Szegedy(g), [1])

    @test measure(qss, initial_state(qss), collect(1:n)) ≈ fill(1/n, (n))
  end
end
