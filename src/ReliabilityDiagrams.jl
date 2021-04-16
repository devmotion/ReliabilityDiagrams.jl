module ReliabilityDiagrams

using AbstractPlotting:
    AbstractPlotting, @extract, @recipe, Attributes, Node, Point2f0, lift
using RecipesBase: RecipesBase
using StatsBase: StatsBase

export EqualSize, EqualMass

include("binning.jl")
include("recipes/makie.jl")
include("recipes/plots.jl")
include("conversions.jl")

end
