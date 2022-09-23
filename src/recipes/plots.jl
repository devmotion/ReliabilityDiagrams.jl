"""
    reliabilityplot(probabilities, frequencies; deviation=true, kwargs...)
    reliabilityplot(probabilities, frequencies, low_high; deviation=true, kwargs...)
    reliabilityplot(probabilities, frequencies, low, high; deviation=true, kwargs...)

Plot a reliability diagram of the observed `frequencies` versus the predicted
`probabilities`, optionally with consistency bars ranging from `low` to `high` for
each probability.

If `deviation` is `true` (default), the difference `frequencies - probabilities` is
plotted versus `probabilities`. This can be helpful for inspecting how closely the
observed frequencies match the predicted probabilities.

# Examples

```jldoctest
julia> probabilities = sort(rand(10));

julia> frequencies = rand(10);

julia> reliabilityplot(probabilities, frequencies);

julia> # plot frequencies instead of deviations
       reliabilityplot(probabilities, frequencies; deviation=false);

julia> # use different colors for markers
       reliabilityplot(probabilities, frequencies; markercolor=:red);

julia> # random consistency bars
       low = max.(0, probabilities .- rand.());

julia> high = min.(1, probabilities .+ rand.());

julia> # plot pre-computed consistency bars
       reliabilityplot(probabilities, frequencies, low, high);

julia> # alternatively consistency bars can be specified as vector of tuples
       reliabilityplot(probabilities, frequencies, map(tuple, low, high));
```

# References

Bröcker, J. and Smith, L.A. (2007). *Increasing the reliability of reliability diagrams*.
Weather and forecasting, 22(3), pp. 651-661.
"""
RecipesBase.@userplot struct ReliabilityPlot{X<:AbstractVector,Y<:AbstractVector,T}
    x::X
    y::Y
    low_high::T
end

"""
    reliabilityplot(
        probabilities::AbstractVector{<:Real},
        outcomes::AbstractVector{Bool};
        binning=EqualMass(),
        consistencybars=ConsistencyBars(),
        kwargs...,
    )

Plot a reliability diagram of the observed frequencies versus the mean probabilities
in different clusters together with a set of consistency bars.

Optionally, the binning algorithm that is used to form the clusters and the consistency
bars can be configured with the `binning` and `consistencybars` keyword arguments. If
`consistencybars === nothing`, then no consistency bars are computed.

# Examples

```jldoctest
julia> probabilities = rand(10);

julia> outcomes = rand(Bool, 10);

julia> # default binning and consistency bars
       reliabilityplot(probabilities, outcomes);

julia> # custom options: without consistency bars
       reliabilityplot(probabilities, outcomes; consistencybars=nothing);
```

See also: [`EqualMass`](@ref), [`EqualSize`](@ref), [`ConsistencyBars`](@ref)
"""
reliabilityplot(::AbstractVector{<:Real}, ::AbstractVector{Bool}; kwargs...)

RecipesBase.@recipe function f(plot::ReliabilityPlot)
    # extract x and y values
    x = plot.x
    y = plot.y

    # compute mean probabilities and frequencies and consistency bars
    probs, freqs_nodeviation, low_high = if y isa AbstractVector{Bool}
        binning = get(plotattributes, :binning, EqualMass())
        consistencybars = get(plotattributes, :consistencybars, ConsistencyBars())
        means_and_bars(x, y; binning=binning, consistencybars=consistencybars)
    else
        x, y, plot.low_high
    end
    deviation::Bool = get(plotattributes, :deviation, true)
    freqs = deviation ? freqs_nodeviation - probs : freqs_nodeviation - zero(probs)

    # default attributes
    seriestype --> :line
    markershape --> :circle
    xlabel --> "confidence"
    ylabel --> deviation ? "empirical deviation" : "empirical frequency"

    # add consistency bars, taking into account the `deviation` keyword argument
    if low_high !== nothing
        low = map(low_high, freqs_nodeviation) do (low, _), freq
            return freq - low
        end
        high = map(low_high, freqs_nodeviation) do (_, high), freq
            return high - freq
        end
        yerror := (low, high)
    end

    return probs, freqs
end
