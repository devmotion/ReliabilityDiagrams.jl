@testset "utils.jl" begin
    @testset "means_bins" begin
        x = rand(100)
        y = rand(Bool, 100)

        for alg in (EqualSize(), EqualMass())
            meanx, meany, b = ReliabilityDiagrams.means_bins(x, y; binning=alg)
            @test meanx isa Vector{Float64}
            @test meany isa Vector{Float64}
            @test b isa Histogram{Int}

            @test 1 ≤ length(meanx) ≤ 10
            @test length(meany) == length(meanx)
            @test numbins(b) == 10

            @test sum(bincounts(b)) == 100

            idxs = [binindex(b, xi) for xi in x]
            for i in 1:10
                idxs_i = findall(==(i), idxs)
                @test length(idxs_i) == bincounts(b)[i]

                iszero(length(idxs_i)) && continue

                @test meanx[i] ≈ mean(x[idxs_i])
                @test meany[i] ≈ mean(y[idxs_i])
            end
        end
    end

    @testset "consistency_ranges" begin
        # consistency bars
        # single prediction
        @test ReliabilityDiagrams.consistency_ranges([0.0], ConsistencyBars()) == (0.0, 0.0)
        @test ReliabilityDiagrams.consistency_ranges([0.5], ConsistencyBars()) == (0.0, 1.0)
        @test ReliabilityDiagrams.consistency_ranges([1.0], ConsistencyBars()) == (1.0, 1.0)

        # multiple predictions
        @test ReliabilityDiagrams.consistency_ranges([0.0, 0.0], ConsistencyBars()) ==
              (0.0, 0.0)
        @test ReliabilityDiagrams.consistency_ranges([0.0, 1.0], ConsistencyBars()) ==
              (0.0, 1.0)
        @test ReliabilityDiagrams.consistency_ranges([1.0, 1.0], ConsistencyBars()) ==
              (1.0, 1.0)

        # dictionary of bins with predictions
        dict = OrderedDict(1 => rand(5), 2 => rand(3), 4 => rand(6))
        ranges = ReliabilityDiagrams.consistency_ranges(
            dict, ConsistencyBars(; samples=100_000)
        )
        @test ranges isa Vector{Tuple{Float64,Float64}}
        @test length(ranges) == 3
        for ((k, probs), range) in zip(dict, ranges)
            ranges_k = ReliabilityDiagrams.consistency_ranges(
                probs, ConsistencyBars(; samples=100_000)
            )
            @test ranges_k[1] ≈ range[1] atol = 1e-2
            @test ranges_k[2] ≈ range[2] atol = 1e-2
        end

        # no consistency bars
        probabilities = OrderedDict{Int,Vector{Float64}}(1 => rand(10), 3 => rand(2))
        ranges = ReliabilityDiagrams.consistency_ranges(probabilities, nothing)
        @test ranges isa Vector{Tuple{Float64,Float64}}
        @test length(ranges) == 2
        @test all(isnan(x[1]) && isnan(x[2]) for x in ranges)
    end

    @testset "means_and_bars" begin
        probabilities = rand(100)
        outcomes = rand(Bool, 100)

        for alg in (EqualSize(), EqualMass())
            mean_predictions, mean_frequencies, ranges = ReliabilityDiagrams.means_and_bars(
                probabilities, outcomes; binning=alg, consistencybars=nothing
            )
            @test length(mean_predictions) == alg.n
            @test length(mean_frequencies) == alg.n
            @test length(ranges) == alg.n

            @test (mean_predictions, mean_frequencies) ==
                  ReliabilityDiagrams.means_bins(probabilities, outcomes; binning=alg)[1:2]
            @test ranges isa Vector{Tuple{Float64,Float64}}
            @test all(isnan(x[1]) && isnan(x[2]) for x in ranges)
        end
    end
end
