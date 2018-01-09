@testset "Getter functions for types" begin
  n = 5
  g = CompleteGraph(n)
  ctqw = CTQW(g)
  qss = QWSearch(ctqw, [1])

  @test QuantumWalk.graph(ctqw) == ctqw.graph
  @test QuantumWalk.graph(qss) == QuantumWalk.graph(qss.model)
  @test QuantumWalk.model(qss) == qss.model
  @test QuantumWalk.parameters(qss) == qss.parameters
end
