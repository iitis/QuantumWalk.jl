@testset "Continuous model check" begin
  n = 5
  g = CompleteGraph(n)

  @testset "Evolution check" begin
    @test continuous_quantum_search(g, [1], π*sqrt(n)/2, Dict("jumprate"=>1/n, "graphmatrix"=>:adjacency))[1] ≈ 1
  end

  @testset "Error check" begin
    @test_throws AssertionError continuous_quantum_search(g, [1], -1, Dict("gamma"=>γ, "graphmatrix"=>:adjacency))
  end
end
