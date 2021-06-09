@testset "utils.jl" begin
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

        for binning in (EqualSize(; n=13), EqualMass(; n=17)),
            consistencybars in (ConsistencyBars(), nothing)
            # compute mean probabilities, frequencies, and consistency ranges
            meanprobabilities, meanfrequencies, ranges = ReliabilityDiagrams.means_and_bars(
                probabilities, outcomes; binning=binning, consistencybars=consistencybars
            )

            # check that length of arrays is consistent
            @test 1 ≤ length(meanprobabilities) ≤ binning.n
            @test length(meanfrequencies) == length(meanfrequencies)
            @test length(ranges) == length(meanfrequencies)

            # ensure that probabilities are sorted
            @test issorted(meanprobabilities)

            # check that length of arrays is correct
            bins = ReliabilityDiagrams.bins(probabilities, outcomes, binning)
            binindices = [ReliabilityDiagrams.binindex(bins, p) for p in probabilities]
            indices = unique(binindices)
            @test length(meanprobabilities) == length(indices)

            # check that values of mean probabilities and frequencies are correct
            indices_of_means = [
                ReliabilityDiagrams.binindex(bins, x) for x in meanprobabilities
            ]
            @test sort(indices) == sort(indices_of_means)
            for (j, index) in enumerate(indices_of_means)
                meanprobs = mean(
                    p for (p, b) in zip(probabilities, binindices) if b == index
                )
                meanfreqs = mean(o for (o, b) in zip(outcomes, binindices) if b == index)
                @test meanprobs ≈ meanprobabilities[j]
                @test meanfreqs ≈ meanfrequencies[j]
            end

            # rough test of consistency ranges
            if consistencybars === nothing
                @test all(isnan(x[1]) && isnan(x[2]) for x in ranges)
            else
                @test all(x[1] ≤ y ≤ x[2] for (x, y) in zip(ranges, meanprobabilities))
            end
        end

        # exception
        for binning in (EqualSize(; n=12), EqualMass(; n=8)),
            consistencybars in (ConsistencyBars(), nothing)

            @test_throws ErrorException ReliabilityDiagrams.means_and_bars(
                rand(100), rand(Bool, 99); binning=binning, consistencybars=consistencybars
            )
            @test_throws ErrorException ReliabilityDiagrams.means_and_bars(
                rand(100), rand(Bool, 101); binning=binning, consistencybars=consistencybars
            )
        end
    end
end
