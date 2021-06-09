# Makie

# without consistency bounds
function Makie.convert_arguments(
    ::Type{<:Reliability},
    probabilities::AbstractVector{<:Real},
    frequencies::AbstractVector{<:Real},
)
    points = map(probabilities, frequencies) do x, y
        return Makie.Point4f0(x, y, NaN32, NaN32)
    end
    return (points,)
end

# with separate consistency bounds
function Makie.convert_arguments(
    ::Type{<:Reliability},
    probabilities::AbstractVector{<:Real},
    frequencies::AbstractVector{<:Real},
    low::AbstractVector{<:Real},
    high::AbstractVector{<:Real},
)
    points = map(probabilities, frequencies, low, high) do x, y, low, high
        return Makie.Point4f0(x, y, low, high)
    end
    return (points,)
end

# with tuples of consistency bounds
function Makie.convert_arguments(
    ::Type{<:Reliability},
    probabilities::AbstractVector{<:Real},
    frequencies::AbstractVector{<:Real},
    low_high::AbstractVector,
)
    points = map(probabilities, frequencies, low_high) do x, y, (low, high)
        return Makie.Point4f0(x, y, low, high)
    end
    return (points,)
end

# with outcomes instead of frequencies
function Makie.used_attributes(
    ::Type{<:Reliability}, ::AbstractVector{<:Real}, ::AbstractVector{<:Bool}
)
    return (:binning, :consistencybars)
end
function Makie.convert_arguments(
    ::Type{P},
    probabilities::AbstractVector{<:Real},
    outcomes::AbstractVector{Bool};
    binning=EqualMass(),
    consistencybars=ConsistencyBars(),
) where {P<:Reliability}
    meanprobabilities, meanfrequencies, low_high = means_and_bars(
        probabilities, outcomes; binning=binning, consistencybars=consistencybars
    )
    return Makie.convert_arguments(P, meanprobabilities, meanfrequencies, low_high)
end

# Plots

# default constructor (recipe forwards arguments as tuple)
function ReliabilityPlot(
    (
        probabilities, frequencies, low_high
    )::Tuple{
        <:AbstractVector{<:Real},
        <:AbstractVector{<:Real},
        <:AbstractVector{<:Tuple{<:Real,<:Real}},
    },
)
    return ReliabilityPlot(probabilities, frequencies, low_high)
end
function ReliabilityPlot(
    (
        probabilities, frequencies, low, high
    )::Tuple{
        <:AbstractVector{<:Real},
        <:AbstractVector{<:Real},
        <:AbstractVector{<:Real},
        <:AbstractVector{<:Real},
    },
)
    return ReliabilityPlot((probabilities, frequencies, map(tuple, low, high)))
end

# without consistency bars
function ReliabilityPlot(
    (
        probabilities, frequencies_or_outcomes
    )::Tuple{<:AbstractVector{<:Real},<:AbstractVector{<:Real}},
)
    return ReliabilityPlot(probabilities, frequencies_or_outcomes, nothing)
end
