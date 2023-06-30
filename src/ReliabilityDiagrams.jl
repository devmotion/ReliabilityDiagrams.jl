module ReliabilityDiagrams

using ConsistencyResampling: ConsistencyResampling
using DataStructures: DataStructures
using Statistics: Statistics
using StatsBase: StatsBase
using StructArrays: StructArrays

using Random: Random

export ConsistencyBars
export EqualSize, EqualMass
export reliability, reliability!, reliabilityplot, reliabilityplot!

include("binning.jl")
include("consistency_bars.jl")
include("utils.jl")

# stumps
function reliability end
function reliability! end
function reliabilityplot end
function reliabilityplot! end

if !isdefined(Base, :get_extension)
    include("../ext/ReliabilityDiagramsRecipesBaseExt.jl")
    include("../ext/ReliabilityDiagramsMakieExt.jl")
end

@static if isdefined(Base, :get_extension)
    function __init__()
        Base.Experimental.register_error_hint(MethodError) do io, exc, _, _
            if exc.f === reliability || exc.f === reliability!
                if isempty(methods(exc.f))
                    print(
                        io,
                        "\nDid you forget to load Makie, CairoMakie, GLMakie, or any other package that loads Makie?",
                    )
                end
            elseif exc.f === reliabilityplot || exc.f === reliabilityplot!
                if isempty(methods(exc.f))
                    print(io, "\nDid you forget to load Plots?")
                end
            end
        end
    end
end

end # module
