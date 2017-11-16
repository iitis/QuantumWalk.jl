@testset "General search test" begin
  n = 5
  g = CompleteGraph(n)

  @test quantumsearch(g, [1], 1., :continuous) ≈   continuous_quantum_search(g, [1], 1.)
  @test quantumsearch(g, [1], 10, :szegedy) ≈ szegedy_quantum_search(g, [1], 10)

  @test_throws AssertionError quantumsearch(g, [1], 10, :classical) 
end
