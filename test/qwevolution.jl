@testset "Quantum walks simulator" begin

  n = 5
  g = CompleteGraph(n)


  @testset "Quantum walks simulator for CTQW" begin
    init = fill(Complex128(1/sqrt(n)), n)
    qwe = QWEvolution(CTQW(g, :adjacency))

    @test_throws AssertionError execute(qwe, init , -1.0)
    @test execute(qwe, init, 1) ≈ execute(qwe, execute(qwe, init, 0.5), 0.5)
  end

  @testset "Quantum walks simulator for Szegedy" begin
    qwe = QWEvolution(Szegedy(g))
    init = spzeros(n*n)
    init[1] = init[n] = init[n*n] = 1/sqrt(3.)
    steps = 10

    @test_throws AssertionError execute(qwe, init, -1)
    @test_throws MethodError execute(qwe, init, 0.5)

    @test execute(qwe, init, steps, all = true, measure = true)[:,steps+1] == execute(qwe, init, steps, all = false, measure = true)
    @test execute(qwe, init, steps, all = true, measure = false)[steps+1] == execute(qwe, init, steps, all = false, measure = false)

  end


end
