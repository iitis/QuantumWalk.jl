@testset "Getter functions for types" begin
  n = 5
  g = CompleteGraph(n)
  ctqw = CTQW(g)
  qws = QWSearch(ctqw, [1])

  @test QuantumWalk.graph(ctqw) == ctqw.graph
  @test QuantumWalk.graph(qws) == QuantumWalk.graph(qws.model)
  @test QuantumWalk.model(qws) == qws.model
  @test QuantumWalk.parameters(qws) == qws.parameters
end
