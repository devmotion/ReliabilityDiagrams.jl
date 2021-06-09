@testset "binning.jl" begin
    @testset "EqualSize" begin
        # default constructor
        @test EqualSize().n == 10

        # exception
        @test_throws ErrorException EqualSize(; n=0)
        @test_throws ErrorException EqualSize(; n=-1)

        # binning
        b = bins(rand(100), rand(100), EqualSize())
        @test b isa Histogram{Int}

        @test numbins(b) == 10
        @test length(b.edges) == 1
        @test first(b.edges) == 0:0.1:1

        @test bincounts(b) isa AbstractVector{Int}
        @test all(iszero, bincounts(b))

        @test binindex(b, prevfloat(0.0)) == 0
        @test binindex(b, 0) == 1
        @test binindex(b, 0.05) == 1
        @test binindex(b, 0.1) == 2
        @test binindex(b, 1) == 10
        @test binindex(b, nextfloat(1.0)) == 11
    end

    @testset "EqualMass" begin
        # default constructor
        @test EqualMass().n == 10

        # exception
        @test_throws ErrorException EqualMass(; n=0)
        @test_throws ErrorException EqualMass(; n=-1)

        # binning
        x = rand(100)
        b = bins(x, rand(100), EqualMass())
        @test b isa Histogram{Int}

        @test numbins(b) == 10
        @test length(b.edges) == 1
        @test first(b.edges) ≈ quantile(x, 0:0.1:1)

        @test bincounts(b) isa AbstractVector{Int}
        @test all(iszero, bincounts(b))

        @test binindex(b, prevfloat(minimum(x))) == 0
        @test binindex(b, minimum(x)) == 1
        @test binindex(b, quantile(x, 0.05)) == 1
        @test binindex(b, quantile(x, 0.1)) == 2
        @test binindex(b, maximum(x)) == 10
        @test binindex(b, nextfloat(maximum(x))) == 11
    end
end
