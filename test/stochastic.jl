@testset "Stochastic Model test" begin
    @testset "QWEvolution test" begin
        # Star graph
        g = StarGraph(4)
        qwe = QWEvolution(UniformStochastic(g))
        @test execute_single(qwe, [1., 0., 0., 0.], 5) ≈ [0., 1. /3, 1. /3, 1. /3]
        @test execute_single_measured(qwe, [1., 0., 0., 0.], 5) ≈ execute_single(qwe, [1., 0., 0., 0.], 5)
        @test isapprox(sum(execute_all(qwe, [1., 0., 0., 0.], 2000))/2000, [0.5, 1. /6, 1. /6, 1. /6], atol=0.001)

        stochastic_matrix = [0.0 0.5 0.7 0.0 0.0;
                             0.3 0.0 0.1 1.0 0.0;
                             0.7 0.4 0.0 0.0 1.0;
                             0.0 0.1 0.0 0.0 0.0;
                             0.0 0.0 0.2 0.0 0.0]
        stoch = Stochastic(stochastic_matrix, smallgraph(:bull))
        qwe = QWEvolution(stoch)
        eigvec_1 = [4.5333, 2.0667, 5, 0.2667, 1.] #calculated by wolfram alpha
        eigvec_1 /= sum(eigvec_1)
        @test isapprox(execute_single(qwe, [1., 0., 0., 0., 0.], 100), eigvec_1, atol = 0.01)
    end

    @testset "QWSearch test" begin
        # Star graph
        g = smallgraph(:bull)
        qwe = QWSearch(UniformStochastic(g), [1])
        @test !(isapprox(state(execute_single(qwe, 1)), [1., 0., 0., 0., 0.], atol = 0.01))
        @test isapprox(state(execute_single(qwe, 100)), [1., 0., 0., 0., 0.], atol = 0.01)

        stochastic_matrix = [0.0 0.5 0.7 0.0 0.0;
                             0.3 0.0 0.1 1.0 0.0;
                             0.7 0.4 0.0 0.0 1.0;
                             0.0 0.1 0.0 0.0 0.0;
                             0.0 0.0 0.2 0.0 0.0]
        stoch = Stochastic(stochastic_matrix, smallgraph(:bull))
        qws = QWSearch(stoch, [1], 0.5)
        @test !(isapprox(state(execute_single(qwe, 1)), [1., 0., 0., 0., 0.], atol = 0.01))
        @test isapprox(state(execute_single(qwe, 100)), [1., 0., 0., 0., 0.], atol = 0.01)
    end

    @testset "Stochastic conversion" begin
      u_stoch = UniformStochastic(smallgraph(:bull))
      qws = QWSearch(u_stoch, [1], 0.5)

      function is_equal_mine(q1::QWSearch, q2::QWSearch)
        model(q1) == model(q2) &&
        parameters(q1)[:stochastic] ≈ parameters(q2)[:stochastic] &&
        penalty(q1) == penalty(q2) &&
        marked(q1) == marked(q2)
      end

      qss1 = QWSearch(qws, marked = [1])
      qss2 = QWSearch(qws, penalty = 0.5)
      qss3 = QWSearch(qws, marked = [2])
      qss4 = QWSearch(qws, penalty = 1.)
      qss5 = QWSearch(qws, marked = [2], penalty = 1.)
      qss6 = QWSearch(qws, marked = [2], penalty = 2.)

      qss1_ref = QWSearch(u_stoch, [1], 0.5)
      qss2_ref = QWSearch(u_stoch, [1], 0.5)
      qss3_ref = QWSearch(u_stoch, [2], 0.5)
      qss4_ref = QWSearch(u_stoch, [1], 1.)
      qss5_ref = QWSearch(u_stoch, [2], 1.)

      @test is_equal_mine(qss1, qss1_ref)
      @test is_equal_mine(qss2, qss2_ref)
      @test is_equal_mine(qss3, qss3_ref)
      @test is_equal_mine(qss4, qss4_ref)
      @test is_equal_mine(qss5, qss5_ref)
      @test !is_equal_mine(qss6, qss5_ref)

      stochastic_matrix = [0.0 0.5 0.7 0.0 0.0;
                           0.3 0.0 0.1 1.0 0.0;
                           0.7 0.4 0.0 0.0 1.0;
                           0.0 0.1 0.0 0.0 0.0;
                           0.0 0.0 0.2 0.0 0.0]
      stoch = Stochastic(stochastic_matrix, smallgraph(:bull))
      qws = QWSearch(stoch, [1], 0.5)

      qss1 = QWSearch(qws, marked = [1])
      qss2 = QWSearch(qws, penalty = 0.5)
      qss3 = QWSearch(qws, marked = [2])
      qss4 = QWSearch(qws, penalty = 1.)
      qss5 = QWSearch(qws, marked = [2], penalty = 1.)
      qss6 = QWSearch(qws, marked = [2], penalty = 2.)

      qss1_ref = QWSearch(stoch, [1], 0.5)
      qss2_ref = QWSearch(stoch, [1], 0.5)
      qss3_ref = QWSearch(stoch, [2], 0.5)
      qss4_ref = QWSearch(stoch, [1], 1.)
      qss5_ref = QWSearch(stoch, [2], 1.)

      @test is_equal_mine(qss1, qss1_ref)
      @test is_equal_mine(qss2, qss2_ref)
      @test is_equal_mine(qss3, qss3_ref)
      @test is_equal_mine(qss4, qss4_ref)
      @test is_equal_mine(qss5, qss5_ref)
      @test !is_equal_mine(qss6, qss5_ref)
  end
end
