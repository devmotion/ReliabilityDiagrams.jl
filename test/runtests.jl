using ReliabilityDiagrams
using AbstractPlotting
using Random
using Statistics
using StatsBase: Histogram, quantile
using Test

using ReliabilityDiagrams:
    ReliabilityPlot, bincounts, binindex, bins, numbins, reliability_summary

Random.seed!(1234)

@testset "ReliabilityDiagrams.jl" begin
    include("binning.jl")
    include("conversions.jl")
end
