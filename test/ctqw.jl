@testset "CTQW model check" begin
  n = 5
  g = CompleteGraph(n)
  ctqw = CTQW(g)
  ctqw_qss = QWSearch(ctqw, [1,3])

  @test isapprox(sum(measure(ctqw_qss, initial_state(ctqw_qss))), 1.0)
  @test QuantumWalk.matrix(ctqw) == ctqw.matrix


  @testset "Default jumping rate" begin
    @test QuantumWalk.jumping_rate(ctqw) ≈ 1./(n-1)
    @test QuantumWalk.jumping_rate(CTQW(Graph(n))) == 1.
    @test_throws AssertionError QuantumWalk.jumping_rate(CTQW(g, :laplacian))
  end
end
