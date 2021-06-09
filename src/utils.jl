# compute mean probabilities and frequencies for a specific binning algorithm
# and return mean probabilities, frequencies, and bins
function means_bins(
    probabilities::AbstractVector{<:Real}, outcomes::AbstractVector{Bool}; binning
)
    # obtain bins
    bins = ReliabilityDiagrams.bins(probabilities, outcomes, binning)

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

# compute ranges of consistency bars
# multiple bins
function consistency_ranges(
    probabilities::DataStructures.OrderedDict{Int,<:AbstractVector{<:Real}}, bars
)
    results = map(values(probabilities)) do probs
        return consistency_ranges(probs, bars)
    end
    return results
end
# single bin
function consistency_ranges(probabilities::AbstractVector{<:Real}, bars::ConsistencyBars)
    probs = similar(probabilities)
    targets = Vector{Bool}(undef, length(probabilities))
    samples = StructArrays.StructArray((probs, targets))
    spl = Random.Sampler(Random.GLOBAL_RNG, ConsistencyResampling.Consistent(probabilities))

    frequencies = map(1:(bars.samples)) do _
        Random.rand!(Random.GLOBAL_RNG, samples, spl)
        return Statistics.mean(targets)
    end

    return StatsBase.quantile(frequencies, bars.quantiles)
end

# no consistency bars
function consistency_ranges(
    probabilities::DataStructures.OrderedDict{Int,<:AbstractVector{<:Real}}, ::Nothing
)
    return fill((NaN, NaN), length(probabilities))
end

# compute mean predictions, frequencies and ranges of consistency bars
function means_and_bars(
    probabilities::AbstractVector{<:Real},
    outcomes::AbstractVector{Bool};
    binning,
    consistencybars,
)
    # bin the probabilities and compute average probabilities and frequencies
    meanprobabilities, meanfrequencies, bins = means_bins(
        probabilities, outcomes; binning=binning
    )

    # estimate consistency ranges
    T = eltype(probabilities)
    binned_probabilities = DataStructures.OrderedDict{Int,Vector{T}}()
    for p in probabilities
        push!(get!(binned_probabilities, binindex(bins, p), Vector{T}(undef, 0)), p)
    end
    low_high = consistency_ranges(binned_probabilities, consistencybars)

    return meanprobabilities, meanfrequencies, low_high
end
