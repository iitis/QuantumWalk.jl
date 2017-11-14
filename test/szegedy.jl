@testset "Szegedy Quantum Walk test" begin
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


end
