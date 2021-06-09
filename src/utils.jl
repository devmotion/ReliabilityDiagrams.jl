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
    length(probabilities) == length(outcomes) ||
        error("number of probabilities and outcomes must be equal")

    # obtain bins
    bins = ReliabilityDiagrams.bins(probabilities, outcomes, binning)
    maxbins = max_nonempty_bins(bins, length(probabilities))

    # compute dictionaries of binned probabilities and mean frequencies of outcomes
    T = eltype(probabilities)
    dict_probabilities = DataStructures.OrderedDict{Int,Vector{T}}()
    dict_meanfrequencies = DataStructures.OrderedDict{Int,Float64}()
    sizehint!(dict_probabilities, maxbins)
    sizehint!(dict_meanfrequencies, maxbins)
    for (probability, outcome) in zip(probabilities, outcomes)
        # compute index of bin
        index = binindex(bins, probability)

        # append to the array of probabilities in the current bin
        bin = get!(dict_probabilities, index, Vector{T}(undef, 0))
        push!(bin, probability)

        # update mean frequency for the current bin
        n = length(bin)
        meanfrequency = get(dict_meanfrequencies, index, 0.0)
        dict_meanfrequencies[index] = meanfrequency + (outcome - meanfrequency) / n
    end

    # compute mean probabilities
    meanprobabilities = map(Statistics.mean, values(dict_probabilities))

    # extract mean frequencies (has the same order!)
    meanfrequencies = collect(values(dict_meanfrequencies))

    # compute consistency ranges (in the same order)
    low_high = consistency_ranges(dict_probabilities, consistencybars)

    # sort results according to mean probabilities
    perm = sortperm(meanprobabilities)
    sorted_meanprobabilities = meanprobabilities[perm]
    sorted_meanfrequencies = meanfrequencies[perm]
    sorted_low_high = low_high[perm]

    return sorted_meanprobabilities, sorted_meanfrequencies, sorted_low_high
end
