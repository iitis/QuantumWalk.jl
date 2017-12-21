@testset "Continuous search check" begin

  @testset "norm test" begin
    qss = QSearch(CTQW(smallgraph(:bull)), [1])
    @test norm(quantum_search(qss, 10).state) ≈ 1
  end

  @testset "CTQW search" begin
    n = 5
    g = CompleteGraph(n)
    qss = QSearch(CTQW(g), [1], 1/n)
    @test sum(quantum_search(qss, pi*sqrt(n)/2).probability) ≈ 1
  end
end

@testset "Discrete search test" begin

  @testset "norm test" begin
    graph = smallgraph(:bull)
    @test norm(quantum_search(QSearch(Szegedy(graph), [1]), 10).state) ≈ 1
  end
end
