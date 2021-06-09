struct ConsistencyBars{T<:Real}
    samples::Int
    quantiles::Tuple{T,T}

    """
        ConsistencyBars(; samples::Int=1_000, coverage::Real=0.95)

    Create consistency bars that cover a proportion of `coverage` samples obtained
    by consistency resampling with `samples` resampling steps.

    # References

    Bröcker, J. and Smith, L.A. (2007). *Increasing the reliability of reliability diagrams*.
    Weather and forecasting, 22(3), pp. 651-661.
    """
    function ConsistencyBars(; samples::Int=1_000, coverage::Real=0.95)
        samples > 0 || error("number of samples must be positive")
        zero(coverage) < coverage < one(coverage) ||
            error("coverage must be a number in (0, 1)")
        αo2 = (1 - coverage) / 2
        quantiles = promote(αo2, 1 - αo2)
        return new{eltype(quantiles)}(samples, quantiles)
    end
end
