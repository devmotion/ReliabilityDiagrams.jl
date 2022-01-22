@testset "conversions.jl" begin
    @testset "Makie" begin
        @testset "frequencies" begin
            probabilities = rand(100)
            frequencies = rand(100)

            # without consistency bounds
            points = convert_arguments(Reliability, probabilities, frequencies)
            @test length(points) == 1
            @test points[1] isa Vector{Point4f}
            @test map(first, points[1]) ≈ probabilities
            @test map(x -> x[2], points[1]) ≈ frequencies
            @test all(isnan(x[3]) for x in points[1])
            @test all(isnan(x[4]) for x in points[1])

            # with consistency bounds
            low = max.(0, probabilities .- rand.())
            high = min.(1, probabilities .+ rand.())
            points = convert_arguments(Reliability, probabilities, frequencies, low, high)
            @test length(points) == 1
            @test points[1] isa Vector{Point4f}
            @test map(first, points[1]) ≈ probabilities
            @test map(x -> x[2], points[1]) ≈ frequencies
            @test map(x -> x[3], points[1]) ≈ low
            @test map(x -> x[4], points[1]) ≈ high

            low_high = map(tuple, low, high)
            points = convert_arguments(Reliability, probabilities, frequencies, low_high)
            @test length(points) == 1
            @test points[1] isa Vector{Point4f}
            @test map(first, points[1]) ≈ probabilities
            @test map(x -> x[2], points[1]) ≈ frequencies
            @test map(x -> x[3], points[1]) ≈ low
            @test map(x -> x[4], points[1]) ≈ high
        end

        @testset "outcomes" begin
            probabilities = rand(100)
            outcomes = rand(Bool, 100)

            for binning in (EqualSize(), EqualMass()),
                consistencybars in (ConsistencyBars(), nothing)

                points = convert_arguments(
                    Reliability,
                    probabilities,
                    outcomes;
                    binning=binning,
                    consistencybars=consistencybars,
                )
                @test length(points) == 1
                @test points[1] isa Vector{Point4f}
                @test length(points[1]) == binning.n

                meanprobs, meanfreqs, _ = ReliabilityDiagrams.means_and_bars(
                    probabilities, outcomes; binning=binning, consistencybars=nothing
                )
                @test map(first, points[1]) ≈ meanprobs
                @test map(x -> x[2], points[1]) ≈ meanfreqs
                if consistencybars === nothing
                    @test all(isnan(x[3]) for x in points[1])
                    @test all(isnan(x[4]) for x in points[1])
                else
                    @test all(x[3] <= x[4] for x in points[1])
                end
            end
        end
    end

    @testset "Plots" begin
        @testset "frequencies" begin
            probabilities = rand(100)
            frequencies = rand(100)

            # without consistency bounds
            plt = ReliabilityPlot((probabilities, frequencies))
            @test plt isa ReliabilityPlot
            @test plt.x == probabilities
            @test plt.y == frequencies
            @test plt.low_high === nothing

            # with consistency bounds
            low = max.(0, probabilities .- rand.())
            high = min.(1, probabilities .+ rand.())
            low_high = map(tuple, low, high)

            plt = ReliabilityPlot((probabilities, frequencies, low, high))
            @test plt isa ReliabilityPlot
            @test plt.x == probabilities
            @test plt.y == frequencies
            @test plt.low_high == low_high

            plt = ReliabilityPlot((probabilities, frequencies, low_high))
            @test plt isa ReliabilityPlot
            @test plt.x == probabilities
            @test plt.y == frequencies
            @test plt.low_high == low_high
        end

        @testset "outcomes" begin
            probabilities = rand(100)
            outcomes = rand(Bool, 100)
            plt = ReliabilityPlot((probabilities, outcomes))
            @test plt isa ReliabilityPlot
            @test plt.x == probabilities
            @test plt.y == outcomes
            @test plt.low_high === nothing
        end
    end
end
