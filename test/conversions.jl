@testset "conversions.jl" begin
    @testset "Reliability" begin
        probabilities = rand(100)
        frequencies = rand(100)

        points = convert_arguments(Reliability, probabilities, frequencies)
        @test length(points) == 1
        @test map(first, points[1]) ≈ probabilities
        @test map(last, points[1]) ≈ frequencies

        outcomes = rand(Bool, 100)
        for alg in (EqualSize(10), EqualMass(10))
            points = convert_arguments(Reliability, probabilities, outcomes, alg)
            @test length(points) == 1

            meanprobs, meanfreqs, _ = reliability_summary(probabilities, outcomes, alg)
            @test map(first, points[1]) ≈ meanprobs
            @test map(last, points[1]) ≈ meanfreqs
        end
    end

    @testset "ReliabilityPlot" begin
        probabilities = rand(100)
        outcomes = rand(Bool, 100)
        for alg in (EqualSize(10), EqualMass(10))
            plt = ReliabilityPlot((probabilities, outcomes, alg))
            @test plt isa ReliabilityPlot

            meanprobs, meanfreqs, _ = reliability_summary(probabilities, outcomes, alg)
            @test plt.probs ≈ meanprobs
            @test plt.freqs ≈ meanfreqs
        end
    end
end
