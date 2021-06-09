@testset "binning.jl" begin
    @testset "EqualSize" begin
        # default constructor
        @test EqualSize().n == 10

        # exception
        @test_throws ErrorException EqualSize(; n=0)
        @test_throws ErrorException EqualSize(; n=-1)

        # binning
        nbins = 11
        b = ReliabilityDiagrams.bins(rand(100), rand(100), EqualSize(; n=nbins))
        @test b isa Histogram{Int}
        @test length(b.weights) == nbins
        @test length(b.edges) == 1
        @test first(b.edges) == range(0; stop=1, length=nbins + 1)

        @test ReliabilityDiagrams.binindex(b, prevfloat(0.0)) == 0
        @test ReliabilityDiagrams.binindex(b, 0) == 1
        @test ReliabilityDiagrams.binindex(b, 0.05) == 1
        @test ReliabilityDiagrams.binindex(b, 0.1) == 2
        @test ReliabilityDiagrams.binindex(b, 1) == nbins
        @test ReliabilityDiagrams.binindex(b, nextfloat(1.0)) == nbins + 1

        @test ReliabilityDiagrams.max_nonempty_bins(b, 1) == 1
        @test ReliabilityDiagrams.max_nonempty_bins(b, nbins - 1) == nbins - 1
        @test ReliabilityDiagrams.max_nonempty_bins(b, nbins) == nbins
        @test ReliabilityDiagrams.max_nonempty_bins(b, nbins + 1) == nbins
    end

    @testset "EqualMass" begin
        # default constructor
        @test EqualMass().n == 10

        # exception
        @test_throws ErrorException EqualMass(; n=0)
        @test_throws ErrorException EqualMass(; n=-1)

        # binning
        x = rand(100)
        nbins = 17
        b = ReliabilityDiagrams.bins(x, rand(100), EqualMass(; n=nbins))
        @test b isa Histogram{Int}
        @test length(b.weights) == nbins
        @test length(b.edges) == 1
        @test first(b.edges) ≈ quantile(x, range(0; stop=1, length=nbins + 1))

        @test ReliabilityDiagrams.binindex(b, prevfloat(minimum(x))) == 0
        @test ReliabilityDiagrams.binindex(b, minimum(x)) == 1
        @test ReliabilityDiagrams.binindex(b, quantile(x, 0.05)) == 1
        @test ReliabilityDiagrams.binindex(b, quantile(x, 0.1)) == 2
        @test ReliabilityDiagrams.binindex(b, maximum(x)) == nbins
        @test ReliabilityDiagrams.binindex(b, nextfloat(maximum(x))) == nbins + 1

        @test ReliabilityDiagrams.max_nonempty_bins(b, 1) == 1
        @test ReliabilityDiagrams.max_nonempty_bins(b, nbins - 1) == nbins - 1
        @test ReliabilityDiagrams.max_nonempty_bins(b, nbins) == nbins
        @test ReliabilityDiagrams.max_nonempty_bins(b, nbins + 1) == nbins
    end
end
