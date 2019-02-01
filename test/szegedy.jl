@testset "Szegedy model test" begin


  @testset "Szegedy walk operators" begin
    g = smallgraph(:bull)
    sz = Szegedy(g, QuantumWalk.uniform_stochastic(g), true)

    @test sqrtstochastic(sz) == sz.sqrtstochastic

    r1, r2 = QuantumWalk.szegedy_walk_operators(sz)
    @test isapprox(norm(r1*r1'-I, Inf), 0, atol=1e-8)
    @test isapprox(norm(r2*r2'-I, Inf), 0, atol=1e-8)

    q1, q2 = QuantumWalk.szegedy_oracle_operators(sz, [2, 3])

    @test all(typeof(m) == SparseMatrixCSC{Float64,Int} for m = [r1, r2, q1, q2])

    @test isapprox(norm(q1*q1'-I, Inf), 0, atol=1e-8)
    @test isapprox(norm(q2*q2'-I, Inf), 0, atol=1e-8)
    @test isdiag(q1)
    @test isdiag(q2)

    # is this the right place for this functions
    v = [1/3,1/3,1/3]
    @test QuantumWalk.proj(v) == v*v'

  end

  @testset "Szegedy initial state and measurement" begin
    g = smallgraph(:bull)
    n = nv(g)
    qws = QWSearch(Szegedy(g), [1])

    @test measure(qws, initial_state(qws), collect(1:n)) ≈ fill(1/n, (n))
  end

  @testset "Szegedy conversion" begin
    szegedy = Szegedy(smallgraph(:bull))
    qws = QWSearch(szegedy, [1], 0.5)

    function is_equal_mine(q1::QWSearch, q2::QWSearch)
      model(q1) == model(q2) &&
      all(parameters(q1)[:operators] .≈ parameters(q2)[:operators]) &&
      penalty(q1) == penalty(q2) &&
      marked(q1) == marked(q2)
    end

    qss1 = QWSearch(qws, marked = [1])
    qss2 = QWSearch(qws, penalty = 0.5)
    qss3 = QWSearch(qws, marked = [2])
    qss4 = QWSearch(qws, penalty = 1.)
    qss5 = QWSearch(qws, marked = [2], penalty = 1.)
    qss6 = QWSearch(qws, marked = [2], penalty = 2.)

    qss1_ref = QWSearch(szegedy, [1], 0.5)
    qss2_ref = QWSearch(szegedy, [1], 0.5)
    qss3_ref = QWSearch(szegedy, [2], 0.5)
    qss4_ref = QWSearch(szegedy, [1], 1.)
    qss5_ref = QWSearch(szegedy, [2], 1.)

    @test is_equal_mine(qss1, qss1_ref)
    @test is_equal_mine(qss2, qss2_ref)
    @test is_equal_mine(qss3, qss3_ref)
    @test is_equal_mine(qss4, qss4_ref)
    @test is_equal_mine(qss5, qss5_ref)
    @test !is_equal_mine(qss6, qss5_ref)
  end
end
