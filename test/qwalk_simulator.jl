@testset "Quantum walks simulator" begin
  
  n = 5
  g = CompleteGraph(n)
  init = fill(Complex128(1/sqrt(n)), n)
  
  @testset "Quantum walks simulator for CTQW" begin
    qws = QWalkSimulator(CTQW(g, :adjacency))

    @test_throws AssertionError walk(qws, init , -1.0)
    @test walk(qws, init, 1) ≈ walk(qws, walk(qws, init, 0.5), 0.5) 
  end
  
  @testset "Quantum walks simulator for Szegedy" begin
    qws = QWalkSimulator(Szegedy(g))
    @test_throws AssertionError walk(qws, init, -1)
    @test_throws MethodError walk(qws, init, 0.5)
    #@test walk(qws, init, 2) == walk(qws, walk(qws, init, 1), 1) 
  end
  
end
