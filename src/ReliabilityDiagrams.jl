module ReliabilityDiagrams

using Makie: Makie, @recipe
using ConsistencyResampling: ConsistencyResampling
using DataStructures: DataStructures
using RecipesBase: RecipesBase
using Statistics: Statistics
using StatsBase: StatsBase
using StructArrays: StructArrays

using Random: Random

export ConsistencyBars
export EqualSize, EqualMass

include("binning.jl")
include("consistency_bars.jl")
include("utils.jl")

include("recipes/makie.jl")
include("recipes/plots.jl")

include("conversions.jl")

end
