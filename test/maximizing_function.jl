@testset "Maximization for quantum search" begin

    n = 5
    g = CompleteGraph(n)
    qss_penalty = ceil(Int, log(nv(g)))

    @testset "Continuous mode" begin

        cqss = QWSearch(CTQW(g), [1], qss_penalty)
        cqss0 = QWSearch(CTQW(g), [1])

        @test_throws AssertionError maximize_quantum_search(cqss, -1.)
        @test_throws AssertionError maximize_quantum_search(cqss, 1., -1.)
        @test runtime(maximize_quantum_search(cqss)) > 0
        @test runtime(maximize_quantum_search(cqss, 1., 1.)) > 0
        @test_warn r".*" maximize_quantum_search(cqss0)
        @test_nowarn maximize_quantum_search(cqss)

        @test isapprox(runtime(maximize_quantum_search(cqss, 1., 0.2)), 1., atol=0.001)

    end

    @testset "Discrete mode" begin
        dqss = QWSearch(Szegedy(g), [1], qss_penalty)
        dqss0 = QWSearch(Szegedy(g), [1])

        @test_throws AssertionError maximize_quantum_search(dqss0, -1)
        @test_throws AssertionError maximize_quantum_search(dqss0, 1, :unknown_mode)
        @test runtime(maximize_quantum_search(dqss)) > 0
        @test runtime(maximize_quantum_search(dqss, nv(g), :firstmaxprob)) > 0
        @test runtime(maximize_quantum_search(dqss, nv(g), :firstmaxeff)) > 0
        @test runtime(maximize_quantum_search(dqss, nv(g), :maxtimeeff)) > 0
        @test runtime(maximize_quantum_search(dqss, nv(g), :maxeff)) > 0
        @test runtime(maximize_quantum_search(dqss, nv(g), :maxtimeprob)) > 0


        @test_warn r".*" maximize_quantum_search(dqss0)
        @test_nowarn maximize_quantum_search(dqss)
    end
end
