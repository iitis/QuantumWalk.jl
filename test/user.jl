@testset "General search test" begin
  n = 5
  g = CompleteGraph(n)

  continuousparam = Dict("jumprate"=>1/n, "graphmatrix"=>:adjacency)
  @test quantumsearch(g, [1], 1., :continuous, continuousparam) ==
          continuous_quantum_search(g, [1], 1., continuousparam)
end
