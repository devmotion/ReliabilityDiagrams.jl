## binning algorithms

struct EqualSize
    "Number of bins."
    n::Int

    @doc """
        EqualSize(; n::Int=10)

    Create binning algorithm with `n` bins of the same size.
    """
    function EqualSize(; n::Int=10)
        n > 0 || error("number of bins must be positive")
        return new(n)
    end
end

struct EqualMass
    "Number of bins."
    n::Int

    @doc """
        EqualMass(; n::Int=10)

    Create binning algorithm with `n` bins of (approximately) equal mass.
    """
    function EqualMass(; n::Int=10)
        n > 0 || error("number of bins must be positive")
        return new(n)
    end
end

function bins(::Any, ::Any, algorithm::EqualSize)
    return StatsBase.Histogram(range(0, 1; length=algorithm.n + 1))
end
function bins(probabilities, ::Any, algorithm::EqualMass)
    return StatsBase.Histogram(StatsBase.nquantile(probabilities, algorithm.n))
end

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

function max_nonempty_bins(bins::StatsBase.Histogram{<:Real,1}, n::Int)
    return min(length(bins.weights), n)
end
