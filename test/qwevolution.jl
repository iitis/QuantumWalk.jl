@testset "Quantum walks simulator" begin

  n = 5
  g = CompleteGraph(n)
  init = fill(Complex128(1/sqrt(n)), n)

  @testset "Quantum walks simulator for CTQW" begin
    qwe = QWEvolution(CTQW(g, :adjacency))

    @test_throws AssertionError execute(qwe, init , -1.0)
    @test execute(qwe, init, 1) ≈ execute(qwe, execute(qwe, init, 0.5), 0.5)
  end

  @testset "Quantum walks simulator for Szegedy" begin
    qwe = QWEvolution(Szegedy(g))
    @test_throws AssertionError execute(qwe, init, -1)
    @test_throws MethodError execute(qwe, init, 0.5)
  end

end
