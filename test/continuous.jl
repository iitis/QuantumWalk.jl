@testset "CTQW model check" begin
  n = 5
  g = CompleteGraph(n)

  @testset "Default jumping rate" begin
    @test QSpatialSearch.jumping_rate(CTQW(g)) ≈ 1./(n-1)
    @test QSpatialSearch.jumping_rate(CTQW(Graph(n))) == 1.
    @test_throws AssertionError QSpatialSearch.jumping_rate(CTQW(g, :laplacian))

  end
end
