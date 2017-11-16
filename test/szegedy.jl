@testset "Szegedy Quantum Walk test" begin
  @testset "Generalized neighbor function" begin
    g = DiGraph(3)
    @test QSpatialSearch.out_neighbors_looped(g, 3) == [3]

    add_edge!(g, 1, 2)
    add_edge!(g, 1, 3)

    @test QSpatialSearch.out_neighbors_looped(g, 1) == [2, 3]
    @test QSpatialSearch.out_neighbors_looped(g, 3) == [3]

    @test QSpatialSearch.out_neighbors_looped(CompleteGraph(3), 3) == [1, 2]
    @test QSpatialSearch.out_neighbors_looped(CompleteDiGraph(3), 3) == [1, 2]

    @test_throws AssertionError QSpatialSearch.out_neighbors_looped(g, 0)
    @test_throws AssertionError QSpatialSearch.out_neighbors_looped(g, 4)
  end

  @testset "Graph stochastic matrix checker" begin
  g = smallgraph(:bull)

  @test isgraphstochastic(g, QSpatialSearch.default_stochastic(g)) == nothing
  @test isgraphstochastic(g, QSpatialSearch.default_stochastic(g) |> full) == nothing

  g = DiGraph(3)
  add_edge!(g, 1, 3)

  @test isgraphstochastic(g, QSpatialSearch.default_stochastic(g)) == nothing
  @test isgraphstochastic(g, QSpatialSearch.default_stochastic(g) |> full) == nothing

   # negative cases

   g = smallgraph(:bull)
   @test_throws AssertionError isgraphstochastic(g, adjacency_matrix(g))
   @test_throws AssertionError isgraphstochastic(CompleteGraph(nv(g)+1), adjacency_matrix(g))
   @test_throws AssertionError isgraphstochastic(DiGraph(nv(g)), adjacency_matrix(g))

   g = DiGraph(3)
   add_edge!(g, 1, 2)
   add_edge!(g, 1, 3)

   @test_throws AssertionError isgraphstochastic(g, [0 0 0; -1 1 0; 2 0 1])
  end

  @testset "Default stochastic matrix" begin
    g = smallgraph(:bull)
    result = [0.0  1./3  1./3  0.0  0.0;
              0.5  0.0   1./3  1.0  0.0;
              0.5  1./3  0.0   0.0  1.0;
              0.0  1./3  0.0   0.0  0.0;
              0.0  0.0   1./3  0.0  0.0]

    @test isapprox(QSpatialSearch.default_stochastic(g), sparse(result), atol=1e-5)

    g = DiGraph(3)
    add_edge!(g, 1, 3)
    @test isapprox(QSpatialSearch.default_stochastic(g), [0 0 0; 0 1 0; 1 0 1], atol=1e-5)
  end

  @testset "Szegedy walk operators" begin
    g = erdos_renyi(5, 0.5, is_directed=true)
    sqrtstochastic = sqrt.(QSpatialSearch.default_stochastic(g))

    r1, r2 = QSpatialSearch.szegedywalkoperators(g, sqrtstochastic)
    @test isapprox(norm(r1*r1'-eye(r1), Inf), 0, atol=1e-8)
    @test isapprox(norm(r2*r2'-eye(r2), Inf), 0, atol=1e-8)

    q1, q2 = QSpatialSearch.szegedyoracleoperators(g, [2, 3])
    @test isapprox(norm(q1*q1'-eye(q1), Inf), 0, atol=1e-8)
    @test isapprox(norm(q2*q2'-eye(q2), Inf), 0, atol=1e-8)
    @test isdiag(q1)
    @test isdiag(q2)
  end

  @testset "Szegedy initial state" begin
    sqrtstochastic = [0 0 sqrt(1/3) 0;
                      sqrt(1/2) 1 0 sqrt(1/3);
                      sqrt(1/2) 0 sqrt(1/3) sqrt(1/3);
                      0 0 sqrt(1/3) sqrt(1/3)]

    result = [sqrtstochastic[y, x] for x=1:4 for y=1:4]/sqrt(4)

    @test QSpatialSearch.szegedyinitialstate(sqrtstochastic) ≈ result
  end

  @testset "Szegedy measurement" begin
    state = zeros(Float64, 4)
    state[1] = state[4] = sqrt(1./2)

    @test QSpatialSearch.szegedymeasurement(state) ≈ [1., 1.]/2

    state = zeros(Complex128, 4)
    state[1] = sqrt(1./2)
    state[2] = 1im * sqrt(1./2)
    @test QSpatialSearch.szegedymeasurement(state) ≈ [1., 0.]

  end




  @testset "Szegedy search test" begin
    graph = smallgraph(:bull)

    @test norm(szegedy_quantum_search(graph, [1], 10, measure=false)) ≈ 1
  end
end
