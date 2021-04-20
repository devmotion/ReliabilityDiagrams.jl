@testset "binning.jl" begin
    @testset "algorithms: EqualSize" begin
        b = bins(rand(100), rand(100), EqualSize(10))
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

    @testset "algorithms: EqualMass" begin
        x = rand(100)
        b = bins(x, rand(100), EqualMass(10))
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

    @testset "reliability_summary" begin
        x = rand(100)
        y = rand(Bool, 100)

        for alg in (EqualSize(10), EqualMass(10))
            meanx, meany, b = reliability_summary(x, y, alg)
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
end
