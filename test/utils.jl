@testset "Basic arrays generators" begin
  @testset "ket" begin
    #standard tests
    @test QSpatialSearch.ket(1, 2) == [1;0]
    #error tests
    @test_throws AssertionError QSpatialSearch.ket(4, 2)
    @test_throws AssertionError QSpatialSearch.ket(-4, -2)
  end

  @testset "bra" begin
    #standard tests
    @test QSpatialSearch.bra(1, 2) == [1 0 ]
    #error tests
    @test_throws AssertionError QSpatialSearch.bra(4, 2)
    @test_throws AssertionError QSpatialSearch.bra(-4, -2)
  end

  @testset "ketbra" begin
    #standard tests
    @test QSpatialSearch.ketbra(1, 2, 3) ==  [0 1 0; 0 0 0; 0 0 0]
    #error tests
    @test_throws AssertionError QSpatialSearch.ketbra(3, 2, 2)
    @test_throws AssertionError QSpatialSearch.ketbra(2, 3, 2)
    @test_throws AssertionError QSpatialSearch.ketbra(-4, -2, -1)
  end

  @testset "proj" begin
    #standard tests#
    result = [0.0+0.0im 0.0+0.0im 0.0+0.0im;
              0.0+0.0im 1.0+0.0im 0.0+0.0im;
              0.0+0.0im 0.0+0.0im 0.0+0.0im]
    @test QSpatialSearch.proj(2, 3) ==  result
    @test QSpatialSearch.proj(1/sqrt(2) * (QSpatialSearch.ket(1, 3)+QSpatialSearch.ket(3, 3))) ≈
                         [0.5+0.0im 0.0+0.0im 0.5+0.0im;
                          0.0+0.0im 0.0+0.0im 0.0+0.0im;
                          0.5+0.0im 0.0+0.0im 0.5+0.0im]
    #error tests
    @test_throws AssertionError QSpatialSearch.proj(2, -1)
    @test_throws AssertionError QSpatialSearch.proj(3, 2)
  end
end

@testset "Array reshuffles" begin
  @testset "res and unres" begin
    #standard tests
    M = Matrix{Float64}(reshape(1:9, (3, 3))')
    v = Vector{Float64}(collect(1:9))
    A = Complex{Float64}[0.354177+0.0im 0.0891553-0.0251879im 0.0702961+0.0516828im 0.0708664+0.0767941im; 0.0891553+0.0251879im 0.336055+0.0im 0.0420202-0.0109173im 0.0683605-0.00692846im; 0.0702961-0.0516828im 0.0420202+0.0109173im 0.212401+0.0im 0.0939615+0.0553555im; 0.0708664-0.0767941im 0.0683605+0.00692846im 0.0939615-0.0553555im 0.0973671+0.0im]
    @test QSpatialSearch.res(M) == v
    @test QSpatialSearch.unres(v) == M
    @test QSpatialSearch.unres(QSpatialSearch.res(M)) == M
    @test QSpatialSearch.res(QSpatialSearch.unres(v)) == v
    @test QSpatialSearch.unres(QSpatialSearch.res(A)) == A
    #error tests
    @test_throws AssertionError QSpatialSearch.unres(collect(1:8)*1.)
  end
end
