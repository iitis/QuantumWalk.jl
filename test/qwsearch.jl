@testset "Continuous search" begin

  @testset "Norm preservation" begin
    g = smallgraph(:bull)
    qss = QWSearch(CTQW(g), [1])
    @test norm(execute_single(qss, 10).state) ≈ 1
  end

  @testset "CTQW search" begin
    n = 5
    g = CompleteGraph(n)
    qss = QWSearch(CTQW(g), [1], 1/n)
    @test sum(execute_single(qss, pi*sqrt(n)/2).probability) ≈ 1
  end
end

@testset "Discrete search" begin
  g = smallgraph(:bull)
  qss = QWSearch(Szegedy(g), [1])

  @testset "Norm preservation" begin
    @test norm(execute_single(qss, 10).state) ≈ 1
  end

  @testset "Evolution" begin
    res = execute_all(qss,10)
    @test res[2].state == QSearchState(qss,evolve(qss,res[1].state),1).state
  end
end
