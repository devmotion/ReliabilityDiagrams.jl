@testset "consistency_bars.jl" begin
    # default values
    bars = ConsistencyBars()
    @test bars.samples == 1_000
    @test bars.quantiles[1] ≈ 0.025
    @test bars.quantiles[2] ≈ 0.975

    # exceptions
    @test_throws ErrorException ConsistencyBars(; samples=0)
    @test_throws ErrorException ConsistencyBars(; samples=-1)
    @test_throws ErrorException ConsistencyBars(; coverage=-0.5)
    @test_throws ErrorException ConsistencyBars(; coverage=1.4)

    # random values
    samples = ceil(Int, abs(randn()))
    coverage = rand()
    bars = ConsistencyBars(; samples=samples, coverage=coverage)
    @test bars.samples == samples
    @test bars.quantiles == promote((1 - coverage) / 2, (1 + coverage) / 2)
end
