using ReliabilityDiagrams

using Aqua
using DataStructures

using Random
using Statistics
using Test

using StatsBase: Histogram, quantile

Random.seed!(1234)

@testset "ReliabilityDiagrams.jl" begin
    include("aqua.jl")
    include("binning.jl")
    include("consistency_bars.jl")
    include("utils.jl")
    include("ext/runtests.jl")
end
