# Makie
function AbstractPlotting.convert_arguments(
    ::Type{<:Reliability},
    probabilities::AbstractVector{<:Real},
    frequencies::AbstractVector{<:Real},
)
    return (map(Point2f0, probabilities, frequencies),)
end

function AbstractPlotting.convert_arguments(
    ::Type{P},
    probabilities::AbstractVector{<:Real},
    outcomes::AbstractVector{Bool},
    algorithm,
) where {P<:Reliability}
    meanprobabilities, meanfrequencies, _ = reliability_summary(
        probabilities, outcomes, algorithm
    )
    return AbstractPlotting.convert_arguments(P, meanprobabilities, meanfrequencies)
end

# Plots
function ReliabilityPlot(
    (
        probabilities, outcomes, algorithm
    )::Tuple{<:AbstractVector{<:Real},<:AbstractVector{Bool},<:Any},
)
    meanprobabilities, meanfrequencies, _ = reliability_summary(
        probabilities, outcomes, algorithm
    )
    return ReliabilityPlot(meanprobabilities, meanfrequencies)
end
