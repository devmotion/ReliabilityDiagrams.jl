## binning algorithms

struct EqualSize
    "Number of bins."
    n::Int

    """
        EqualSize(; n::Int=10)

    Create binning algorithm of the probability simplex with `n` bins of the same size.
    """
    function EqualSize(; n::Int=10)
        n > 0 || error("number of bins must be positive")
        return new(n)
    end
end

struct EqualMass
    "Number of bins."
    n::Int

    """
        EqualMass(; n::Int=10)

    Create binning algorithm with `n` bins of (approximately) equal number of probabilities.
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
