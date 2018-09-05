@testset "General" begin
  g = smallgraph(:bull)
  qws = QWSearch(Szegedy(g), [1])

  @test check_qwdynamics(qws) == nothing
  @test_throws AssertionError QWSearch(Szegedy(g), Dict{Symbol, Any}(), [1], 0., check=true)
  @test_no_error QWSearch(Szegedy(g), Dict{Symbol, Any}(), [1], 0., check=false)
end

@testset "Continuous search" begin
  @testset "General" begin
    g = smallgraph(:bull)
    qws = QWSearch(CTQW(g), [1])
    @test check_qwdynamics(qws) == nothing
  end

  @testset "Norm preservation" begin
    g = smallgraph(:bull)
    qws = QWSearch(CTQW(g), [1])
    @test norm(execute_single(qws, 10).state) ≈ 1

    qws = QWSearch(CTQWDense(g), [1])
    @test norm(execute_single(qws, 10).state) ≈ 1
  end

  @testset "CTQW and CTQWDense arch" begin
    n = 5
    g = CompleteGraph(n)
    qws = QWSearch(CTQW(g), [1], 0, 1/n)
    s0 =  QSearchState(qws, real(initial_state(qws)), 0.0)
    @test sum(execute_single(qws, pi*sqrt(n)/2).probability) ≈ 1
    @test evolve(qws,evolve(qws,s0,0.1),0.1) ≈ evolve(qws,s0,0.2)

    qws = QWSearch(CTQWDense(g), [1], 0, 1/n)
    @test sum(execute_single(qws, pi*sqrt(n)/2).probability) ≈ 1


    n = 5
    g = CycleGraph(5)
    qss_adj = QWSearch(CTQW(g, :adjacency), [1], 0, 1/2)
    qss_lap = QWSearch(CTQW(g, :laplacian), [1], 0, 1/2)
    qss_normlap = QWSearch(CTQW(g, :normalized_laplacian), [1], 0, 1)
    @test sum(execute_single(qss_adj, 2.).probability) ≈ sum(execute_single(qss_lap, 2.).probability)
    @test sum(execute_single(qss_adj, 2.).probability) ≈ sum(execute_single(qss_normlap, 2.).probability)
  end
end

@testset "Discrete search" begin
  g = smallgraph(:bull)
  qws = QWSearch(Szegedy(g), [1])

  @testset "General" begin
    @test check_qwdynamics(qws) == nothing
  end


  @testset "Norm preservation" begin
    @test norm(execute_single(qws, 10).state) ≈ 1
  end

  @testset "Evolution" begin
    steps = 10
    res0 = execute(qws,steps)
    res1 = execute(qws,steps,all=true)
    res2 = execute_all(qws,steps)
    res3 = execute_single(qws,steps)
    # some funky constructions
    @test res1[2].state == QSearchState(qws,evolve(qws,res2[1].state),1).state
    @test res1[10].probability == res2[10].probability
    @test res3.state == res1[11].state
    @test res0.state == res1[11].state
    @test length(res1) == steps+1
    # more straightforward tests
    @test execute_all_measured(qws,steps) == execute(qws,steps,all=true,measure=true)
    @test execute_single_measured(qws,steps) == execute(qws,steps,measure=true)
    @test probability(res3) == res1[steps+1].probability
    @test state(res3) == res1[steps+1].state
    @test state(execute_single(qws,1)) == execute_single(qws,1).state

    s = evolve(qws, QuantumWalk.initial_state(qws))
    @test evolve(qws, s) == evolve(qws, evolve(qws, QuantumWalk.initial_state(qws)))
  end

  @testset "Measurement" begin
    s = QSearchState(qws, initial_state(qws),0)
    @test sum(measure(qws,s)) ≈ 1
    @test sum(measure(qws,s,[1,2,3])) + sum(measure(qws,s,[4,5])) ≈ 1
  end
end
