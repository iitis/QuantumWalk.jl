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
    steps = 10
    res1 = execute(qss,steps,all=true)
    res2 = execute_all(qss,steps)
    res3 = execute_single(qss,steps)
    # some funky constructions
    @test res1[2].state == QSearchState(qss,evolve(qss,res2[1].state),1).state
    @test res1[10].probability == res2[10].probability
    @test res3.state == res1[11].state
    @test length(res1) == steps+1
    # more straightforward tests
    @test execute_all_measured(qss,steps) == execute(qss,steps,all=true,measure=true)
    @test execute_single_measured(qss,steps) == execute(qss,steps,measure=true)
    @test probability(res3) == res1[steps+1].probability
    @test state(res3) == res1[steps+1].state
  end
end
