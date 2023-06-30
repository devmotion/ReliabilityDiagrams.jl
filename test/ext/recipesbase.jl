@testset "RecipesBase" begin
    @testset "frequencies" begin
        probabilities = rand(100)
        frequencies = rand(100)

        # without consistency bounds
        plt = ReliabilityDiagramsRecipesBaseExt.ReliabilityPlot((
            probabilities, frequencies
        ))
        @test plt isa ReliabilityDiagramsRecipesBaseExt.ReliabilityPlot
        @test plt.x == probabilities
        @test plt.y == frequencies
        @test plt.low_high === nothing

        # with consistency bounds
        low = max.(0, probabilities .- rand.())
        high = min.(1, probabilities .+ rand.())
        low_high = map(tuple, low, high)

        plt = ReliabilityDiagramsRecipesBaseExt.ReliabilityPlot((
            probabilities, frequencies, low, high
        ))
        @test plt isa ReliabilityDiagramsRecipesBaseExt.ReliabilityPlot
        @test plt.x == probabilities
        @test plt.y == frequencies
        @test plt.low_high == low_high

        plt = ReliabilityDiagramsRecipesBaseExt.ReliabilityPlot((
            probabilities, frequencies, low_high
        ))
        @test plt isa ReliabilityDiagramsRecipesBaseExt.ReliabilityPlot
        @test plt.x == probabilities
        @test plt.y == frequencies
        @test plt.low_high == low_high
    end

    @testset "outcomes" begin
        probabilities = rand(100)
        outcomes = rand(Bool, 100)
        plt = ReliabilityDiagramsRecipesBaseExt.ReliabilityPlot((probabilities, outcomes))
        @test plt isa ReliabilityDiagramsRecipesBaseExt.ReliabilityPlot
        @test plt.x == probabilities
        @test plt.y == outcomes
        @test plt.low_high === nothing
    end
end
