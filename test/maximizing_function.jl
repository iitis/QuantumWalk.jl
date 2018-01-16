@testset "Maximization for quantum search" begin
    n = 5
    g = CompleteGraph(n)
    qss = QWSearch(CTQW(g), [1])

    @test_throws AssertionError maximize_quantum_search(qss, -1.)
end
