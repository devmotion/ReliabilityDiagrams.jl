# Loading extensions
if isdefined(Base, :get_extension)
    @testset "Extension error messages" begin
        # Makie
        @test Base.get_extension(ReliabilityDiagrams, :ReliabilityDiagramsMakieExt) ===
            nothing
        for f in (reliability, reliability!)
            @test_throws r"^MethodError:.*\nDid you forget to load Makie, CairoMakie, GLMakie, or any other package that loads Makie\?" f()
        end

        # RecipesBase
        @test Base.get_extension(
            ReliabilityDiagrams, :ReliabilityDiagramsRecipesBaseExt
        ) === nothing
        for f in (reliabilityplot, reliabilityplot!)
            @test_throws r"^MethodError:.*\nDid you forget to load Plots\?" f()
        end
    end
end

using Makie
const ReliabilityDiagramsMakieExt = if isdefined(Base, :get_extension)
    Base.get_extension(ReliabilityDiagrams, :ReliabilityDiagramsMakieExt)
else
    ReliabilityDiagrams.ReliabilityDiagramsMakieExt
end

using RecipesBase
const ReliabilityDiagramsRecipesBaseExt = if isdefined(Base, :get_extension)
    Base.get_extension(ReliabilityDiagrams, :ReliabilityDiagramsRecipesBaseExt)
else
    ReliabilityDiagrams.ReliabilityDiagramsRecipesBaseExt
end

@testset "Extensions" begin
    @testset "Makie" begin
        @test ReliabilityDiagramsMakieExt isa Module
        include("makie.jl")
    end

    @testset "RecipesBase" begin
        @test ReliabilityDiagramsRecipesBaseExt isa Module
        include("recipesbase.jl")
    end
end
