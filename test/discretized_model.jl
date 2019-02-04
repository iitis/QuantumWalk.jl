@testset "discretized model" begin
    @testset "general" begin
        n = 100
        g = barabasi_albert(n, 3, seed=10)
        qwe = DiscretizedQWModel(CTQW(g), 1/pi)

        @test abs(inttoreal_runtime(qwe, realtoint_runtime(qwe, 21.)) - 21.) <= granulation(qwe)
        @test abs(realtoint_runtime(qwe, inttoreal_runtime(qwe, 11)) - 11) <= 1
    end

    @testset "QWEvolution" begin
        n = 100
        g = barabasi_albert(n, 3, seed=10)
        ctqw_model = CTQW(g)
        qwe_orig = QWEvolution(ctqw_model)
        qwe_discr = QWEvolution(DiscretizedQWModel(ctqw_model))
        qwe_discr_half = QWEvolution(DiscretizedQWModel(ctqw_model, .5))

        state = zeros(Float64, n)
        state[1] = 1.

        m_base_orig = measure(qwe_orig, evolve(qwe_orig, state, 50.))
        m_base_orig_part = measure(qwe_orig, evolve(qwe_orig, state, 50.), [1,4,6])

        m_base_discr = execute_single_measured(qwe_discr, state, 50)
        m_base_discr_part = measure(qwe_discr, execute_single(qwe_discr, state, 50), [1,4,6])
        @test isapprox(m_base_orig, m_base_discr, atol=0.00001)
        @test isapprox(m_base_orig_part, m_base_discr_part, atol=0.00001)

        m_base_discr = execute_single_measured(qwe_discr_half, state, 100)
        m_base_discr_part = measure(qwe_discr_half, execute_single(qwe_discr_half, state, 100), [1,4,6])
        @test isapprox(m_base_orig, m_base_discr, atol=0.00001)
        @test isapprox(m_base_orig_part, m_base_discr_part, atol=0.00001)

        state = fill(1. / sqrt(n), n)
        m_base_orig = measure(qwe_orig, evolve(qwe_orig, state, 11.))
        m_base_orig_part = measure(qwe_orig, evolve(qwe_orig, state, 11.), [1,4,6])

        m_base_discr = execute_single_measured(qwe_discr, state, 11)
        m_base_discr_part = measure(qwe_discr, execute_single(qwe_discr, state, 11), [1,4,6])
        @test isapprox(m_base_orig, m_base_discr, atol=0.00001)
        @test isapprox(m_base_orig_part, m_base_discr_part, atol=0.00001)

        m_base_discr = execute_single_measured(qwe_discr_half, state, 22)
        m_base_discr_part = measure(qwe_discr_half, execute_single(qwe_discr_half, state, 22), [1,4,6])
        @test isapprox(m_base_orig, m_base_discr, atol=0.00001)
        @test isapprox(m_base_orig_part, m_base_discr_part, atol=0.00001)
    end

    #=@testset "QWSearch" begin
        n = 100
        g = CompleteGraph(n)
        marked_v = [1,2]
        ctqw_model = CTQW(g)
        qwe_orig = QWSearch(ctqw_model, marked_v, 1. / n)
        qwe_discr = QWSearch(DiscretizedQWModel(ctqw_model, .5))

    end
end
