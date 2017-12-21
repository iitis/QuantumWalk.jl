@testset "Continuous search" begin

  @testset "Norm preservation" begin
    g = smallgraph(:bull)
    qss = QSearch(CTQW(g), [1])
    @test norm(quantum_search(qss, 10).state) ≈ 1
  end

  @testset "CTQW search" begin
    n = 5
    g = CompleteGraph(n)
    qss = QSearch(CTQW(g), [1], 1/n)
    @test sum(quantum_search(qss, pi*sqrt(n)/2).probability) ≈ 1
  end
end

@testset "Discrete search" begin
  g = smallgraph(:bull)
  qss = QSearch(Szegedy(g), [1])
  
  @testset "Norm preservation" begin
    @test norm(quantum_search(qss, 10).state) ≈ 1
  end
  
  @testset "Arguments" begin
    @test_throws AssertionError all_quantum_search(qss, -1)
    @test_throws AssertionError all_measured_quantum_search(qss, -1)
    @test_throws AssertionError maximize_quantum_search(qss, -1)
    @test_throws AssertionError maximize_quantum_search(qss, 1, :unknown)
  end
  
  @testset "Evolution" begin
    res = all_quantum_search(qss,10)
    @test res[2].state == QSearchState(qss,evolve(qss,res[1].state),1).state
  end
end
