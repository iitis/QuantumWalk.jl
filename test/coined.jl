@testset "Coined Quantum Walk test" begin
  @testset "default_coin_operator" begin
    @test QSpatialSearch.default_coin_operator(1) ≈ ones(1, 1)
    @test QSpatialSearch.default_coin_operator(2) ≈ [0 1; 1 0]
    @test QSpatialSearch.default_coin_operator(3) ≈ [-1/3 2/3 2/3;
                                      2/3 -1/3 2/3;
                                      2/3 2/3 -1/3]

    @test typeof(QSpatialSearch.default_coin_operator(3)) == SparseMatrixCSC{Float64,Int64}

    @test_throws AssertionError QSpatialSearch.default_coin_operator(0)
    @test_throws AssertionError QSpatialSearch.default_coin_operator(-1)
  end


end
