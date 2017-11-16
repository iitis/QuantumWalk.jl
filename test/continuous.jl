@testset "Continuous model check" begin
  n = 5
  g = CompleteGraph(n)

  @testset "Default jumping rate" begin
    @test QSpatialSearch.default_jumping_rate(g, :adjacency) ≈ 1./(n-1)
    @test QSpatialSearch.default_jumping_rate(Graph(n), :adjacency) == 1.
    @test_throws AssertionError QSpatialSearch.default_jumping_rate(g, :laplacian)

  end

  @testset "CTQW search" begin
    @test continuous_quantum_search(g, [1], π*sqrt(n)/2, graphmatrixsymbol=:adjacency, jumpingrate=1/n, measure=true)[1] ≈ 1
  end

  @testset "Simple evolution" begin
    @test abs.(QSpatialSearch.continuous_evolution([1 1; 1 3]/2, pi/sqrt(2), [1., 1.]/sqrt(2))) ≈ [0., 1.]
    @test abs.(QSpatialSearch.continuous_evolution(sparse([1 1; 1 3]/2), pi/sqrt(2), [1., 1.]/sqrt(2))) ≈ [0., 1.]
  end

  @testset "CTQW search errors" begin
    @test_throws AssertionError continuous_quantum_search(g, [1], -1.)
    @test_throws AssertionError continuous_quantum_search(g, Vector{Int64}([]), 1)
    @test_throws AssertionError continuous_quantum_search(g, [-1 ,2], 1)

    @test_throws AssertionError continuous_quantum_search(ones(5, 5), [1], -1.)
    @test_throws AssertionError continuous_quantum_search(ones(5, 5), Vector{Int64}([]), 1)
    @test_throws AssertionError continuous_quantum_search(ones(5, 5), [-1 ,2], 1)
  end
end
