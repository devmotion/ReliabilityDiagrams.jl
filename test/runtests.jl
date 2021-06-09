using ReliabilityDiagrams

using DataStructures
using Makie

using Random
using Statistics
using Test

using ReliabilityDiagrams: ReliabilityPlot
using StatsBase: Histogram, quantile

Random.seed!(1234)

@testset "ReliabilityDiagrams.jl" begin
    include("binning.jl")
    include("consistency_bars.jl")
    include("utils.jl")

    include("conversions.jl")
end
