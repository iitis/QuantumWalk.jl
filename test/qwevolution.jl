@testset "Quantum walks simulator" begin

  n = 5
  g = CompleteGraph(n)

  @testset "General" begin
    qwe = QWEvolution(Szegedy(g))

    @test_throws AssertionError QWEvolution(Szegedy(g), Dict{Symbol,Any}(), check=true)
    @test_no_error QWEvolution(Szegedy(g), Dict{Symbol,Any}(), check=false)
    @test check_qwdynamics(qwe) == nothing
  end

  @testset "Quantum walks simulator for CTQW" begin
    init = fill(ComplexF64(1/sqrt(n)), n)
    ctqwAdj = CTQW(g, :adjacency)
    ctqwLap = CTQW(g, :laplacian)
    ctqwAdjDense = CTQWDense(g, :adjacency)
    ctqwLapDense = CTQWDense(g, :laplacian)
    qweAdj = QWEvolution(ctqwAdj)
    qweLap = QWEvolution(ctqwLap)
    qweAdjDense = QWEvolution(ctqwAdjDense)
    qweLapDense = QWEvolution(ctqwLapDense)


    @test_throws AssertionError execute(qweAdj, init , -1.0)

    @test check_qwdynamics(qweAdj) == nothing

    @test execute(qweAdj, init, 1) ≈ execute(qweAdj, execute(qweAdj, init, 0.5), 0.5)

    @test_throws AssertionError execute(qweLap, init , -1.0)
    @test execute(qweLap, init, 1) ≈ execute(qweLap, execute(qweLap, init, 0.5), 0.5)

    # due to sign issue the measure function is needed
    @test measure(qweAdj, execute(qweAdj, init, 1)) ≈ measure(qweLap, execute(qweLap, init, 1))
    @test measure(qweAdjDense, execute(qweAdjDense, init, 1)) ≈ measure(qweLapDense, execute(qweLapDense, init, 1))

    @test_throws ErrorException QWEvolution(CTQW(g, :notimplemented))
  end

  @testset "Quantum walks simulator for Szegedy" begin
    qwe = QWEvolution(Szegedy(g))
    init = spzeros(n*n)
    init[1] = init[n] = init[n*n] = 1/sqrt(3.)

    steps = 10

    @test check_qwdynamics(qwe) == nothing

    @test_throws AssertionError execute(qwe, init, -1)
    @test_throws MethodError execute(qwe, init, 0.5)

    @test execute(qwe, init, steps, all = true, measure = true)[:,steps+1] == execute(qwe, init, steps, all = false, measure = true)
    @test execute(qwe, init, steps, all = true, measure = false)[steps+1] == execute(qwe, init, steps, all = false, measure = false)

  end


end
