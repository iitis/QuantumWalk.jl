@testset "Maximization for quantum search" begin

    n = 5
    g = CompleteGraph(n)
    qss_penalty = ceil(Int, log(nv(g)))

    @testset "Continuous mode" begin

        cqss = QWSearch(CTQW(g), [1], nv(g), qss_penalty)
        cqss0 = QWSearch(CTQW(g), [1], nv(g))

        @test_throws AssertionError maximize_quantum_search(cqss, -1.)
        @test runtime(maximize_quantum_search(cqss)) > qss_penalty
        @test_warn r".*" maximize_quantum_search(cqss0)
        @test_nowarn maximize_quantum_search(cqss)
    end

    @testset "Discrete mode" begin
        dqss = QWSearch(Szegedy(g), [1], qss_penalty)
        dqss0 = QWSearch(Szegedy(g), [1])
        
        @test_throws AssertionError maximize_quantum_search(dqss0, -1)
        @test_throws AssertionError maximize_quantum_search(dqss0, 1, :unknown_mode)
        @test runtime(maximize_quantum_search(dqss)) > qss_penalty
        @test runtime(maximize_quantum_search(dqss, nv(g), :firstmaxprob)) > qss_penalty
        @test runtime(maximize_quantum_search(dqss, nv(g), :firstmaxeff)) > qss_penalty
        @test runtime(maximize_quantum_search(dqss, nv(g), :maxtimeeff)) > qss_penalty
        @test runtime(maximize_quantum_search(dqss, nv(g), :maxeff)) > qss_penalty
        @test runtime(maximize_quantum_search(dqss, nv(g), :maxtimeprob)) > qss_penalty

        @test_warn r".*" maximize_quantum_search(dqss0)
        @test_nowarn maximize_quantum_search(dqss)
    end
end
