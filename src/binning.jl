function reliability_summary(
    probabilities::AbstractVector{<:Real}, outcomes::AbstractVector{Bool}, algorithm
)
    # obtain bins
    bins = ReliabilityDiagrams.bins(probabilities, outcomes, algorithm)

    # initialize arrays for mean probabilities and frequencies
    counts = bincounts(bins)
    n = numbins(bins)
    meanprobabilities = zeros(n)
    meanfrequencies = zeros(n)

    # compute mean probabilities and frequencies in each bin
    for (p, o) in zip(probabilities, outcomes)
        index = binindex(bins, p)
        if 1 <= index <= n
            @inbounds begin
                c = (counts[index] += 1)
                meanprobabilities[index] += (p - meanprobabilities[index]) / c
                meanfrequencies[index] += (o - meanfrequencies[index]) / c
            end
        end
    end

    # return mean probabilities and frequencies in non-empty bins
    nonzero = findall(!iszero, counts)
    return meanprobabilities[nonzero], meanfrequencies[nonzero], bins
end

## binning algorithms

"""
    EqualSize(n::Int)

Create binning algorithm of the probability simplex with `n` bins of the same size.
"""
struct EqualSize
    "Number of bins."
    n::Int
end

"""
    EqualMass(n::Int)

Create binning algorithm with `n` bins of (approximately) equal number of probabilities.
"""
struct EqualMass
    "Number of bins."
    n::Int
end

function bins(::Any, ::Any, algorithm::EqualSize)
    return StatsBase.Histogram(range(0, 1; length=algorithm.n + 1))
end
function bins(probabilities, ::Any, algorithm::EqualMass)
    return StatsBase.Histogram(StatsBase.nquantile(probabilities, algorithm.n))
end

bincounts(bins::StatsBase.Histogram{<:Real,1}) = vec(bins.weights)

numbins(bins::StatsBase.Histogram{<:Real,1}) = length(bins.weights)

function binindex(bins::StatsBase.Histogram{<:Real,1}, x::Real)
    index = StatsBase.binindex(bins, x)
    nbins = length(bins.weights)
    edges = first(bins.edges)
    return if index == 0 && x == first(edges)
        1
    elseif index == nbins + 1 && x == last(edges)
        nbins
    else
        index
    end
end
