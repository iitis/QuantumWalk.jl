@testset "CTQW model check" begin
  n = 5
  g = CompleteGraph(n)
  ctqw = CTQW(g)
  ctqw_qss = QWSearch(ctqw, [1,3])

  @test isapprox(sum(measure(ctqw_qss, initial_state(ctqw_qss))), 1.0)
  @test QuantumWalk.matrix(ctqw) == ctqw.matrix


  @testset "Default jumping rate" begin
    @test QuantumWalk.jumping_rate(ctqw) ≈ 1. /(n-1)
    @test QuantumWalk.jumping_rate(CTQW(Graph(n))) == 1.
    @test_throws AssertionError QuantumWalk.jumping_rate(CTQW(g, :laplacian))
  end

  @testset "CTQW conversion" begin
    ctqw = CTQW(smallgraph(:bull))
    qws = QWSearch(ctqw, [1], 0.5)

    function is_equal_mine(q1::QWSearch, q2::QWSearch)
      model(q1) == model(q2) &&
      parameters(q1)[:hamiltonian] ≈ parameters(q2)[:hamiltonian] &&
      penalty(q1) == penalty(q2) &&
      marked(q1) == marked(q2)
    end

    qss1 = QWSearch(qws, marked = [1])
    qss2 = QWSearch(qws, penalty = 0.5)
    qss3 = QWSearch(qws, marked = [2])
    qss4 = QWSearch(qws, penalty = 1.)
    qss5 = QWSearch(qws, marked = [2], penalty = 1.)
    qss6 = QWSearch(qws, marked = [2], penalty = 2.)

    qss1_ref = QWSearch(ctqw, [1], 0.5)
    qss2_ref = QWSearch(ctqw, [1], 0.5)
    qss3_ref = QWSearch(ctqw, [2], 0.5)
    qss4_ref = QWSearch(ctqw, [1], 1.)
    qss5_ref = QWSearch(ctqw, [2], 1.)

    @test is_equal_mine(qss1, qss1_ref)
    @test is_equal_mine(qss2, qss2_ref)
    @test is_equal_mine(qss3, qss3_ref)
    @test is_equal_mine(qss4, qss4_ref)
    @test is_equal_mine(qss5, qss5_ref)
    @test !is_equal_mine(qss6, qss5_ref)
  end
end

@testset "CTQWDense model check" begin
  n = 5
  g = CompleteGraph(n)
  ctqw = CTQWDense(g)
  ctqw_qss = QWSearch(ctqw, [1,3])

  @test isapprox(sum(measure(ctqw_qss, initial_state(ctqw_qss))), 1.0)
  @test QuantumWalk.matrix(ctqw) == ctqw.matrix


  @testset "Default jumping rate" begin
    @test QuantumWalk.jumping_rate(ctqw) ≈ 1. /(n-1)
    @test QuantumWalk.jumping_rate(CTQWDense(Graph(n))) == 1.
    @test_throws AssertionError QuantumWalk.jumping_rate(CTQWDense(g, :laplacian))
  end

  @testset "CTQWDense conversion" begin
    ctqw = CTQWDense(smallgraph(:bull))
    qws = QWSearch(ctqw, [1], 0.5)

    function is_equal_mine(q1::QWSearch, q2::QWSearch)
      model(q1) == model(q2) &&
      parameters(q1)[:hamiltonian] ≈ parameters(q2)[:hamiltonian] &&
      penalty(q1) == penalty(q2) &&
      marked(q1) == marked(q2)
    end

    qss1 = QWSearch(qws, marked = [1])
    qss2 = QWSearch(qws, penalty = 0.5)
    qss3 = QWSearch(qws, marked = [2])
    qss4 = QWSearch(qws, penalty = 1.)
    qss5 = QWSearch(qws, marked = [2], penalty = 1.)
    qss6 = QWSearch(qws, marked = [2], penalty = 2.)

    qss1_ref = QWSearch(ctqw, [1], 0.5)
    qss2_ref = QWSearch(ctqw, [1], 0.5)
    qss3_ref = QWSearch(ctqw, [2], 0.5)
    qss4_ref = QWSearch(ctqw, [1], 1.)
    qss5_ref = QWSearch(ctqw, [2], 1.)

    @test is_equal_mine(qss1, qss1_ref)
    @test is_equal_mine(qss2, qss2_ref)
    @test is_equal_mine(qss3, qss3_ref)
    @test is_equal_mine(qss4, qss4_ref)
    @test is_equal_mine(qss5, qss5_ref)
    @test !is_equal_mine(qss6, qss5_ref)
  end
end
