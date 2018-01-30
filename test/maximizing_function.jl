@testset "Maximization for quantum search" begin
    n = 5
    g = CompleteGraph(n)
    qss = QWSearch(CTQW(g), [1], nv(g), ceil(Int, log(nv(g))))

    @test_throws AssertionError maximize_quantum_search(qss, -1.)
    @test runtime(maximize_quantum_search(qss)) > ceil(Int, log(nv(g)))
end
