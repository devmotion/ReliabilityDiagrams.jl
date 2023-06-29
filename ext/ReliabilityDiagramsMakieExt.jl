module ReliabilityDiagramsMakieExt

using ReliabilityDiagrams
using Makie: Makie, @recipe

import ReliabilityDiagrams: reliability, reliability!

## Recipe

"""
    reliability(probabilities, frequencies; deviation=true, kwargs...)
    reliability(probabilities, frequencies, low_high; deviation=true, kwargs...)
    reliability(probabilities, frequencies, low, high; deviation=true, kwargs...)

Plot a reliability diagram of the observed `frequencies` versus the predicted
`probabilities`, optionally with consistency bars ranging from `low` to `high` for
each probability.

If `deviation` is `true` (default), the difference `frequencies - probabilities` is
plotted versus `probabilities`. This can be helpful for inspecting how closely the
observed frequencies match the predicted probabilities.

## Attributes

$(Makie.ATTRIBUTES)

### General Axis Keywords

- `xlabel`: Label of x axis (default: `confidence`)
- `ylabel`: Label of y axis (default: if `deviation == true`, then `empirical deviation`, otherwise `empirical frequency`)

# Examples

```jldoctest
julia> probabilities = sort(rand(10));

julia> frequencies = rand(10);

julia> reliability(probabilities, frequencies);

julia> # plot frequencies instead of deviations
       reliability(probabilities, frequencies; deviation=false);

julia> # use different colors for markers
       reliability(probabilities, frequencies; markercolor=:red);

julia> # random consistency bars
       low = max.(0, probabilities .- rand.());

julia> high = min.(1, probabilities .+ rand.());

julia> # plot pre-computed consistency bars
       reliability(probabilities, frequencies, low, high);

julia> # alternatively consistency bars can be specified as vector of tuples
       reliability(probabilities, frequencies, map(tuple, low, high));
```

# References

Bröcker, J. and Smith, L.A. (2007). *Increasing the reliability of reliability diagrams*.
Weather and forecasting, 22(3), pp. 651-661.
"""
@recipe(Reliability, x_y_low_high) do scene
    return Makie.Attributes(;
        color=Makie.theme(scene, :linecolor),
        colormap=Makie.theme(scene, :colormap),
        colorrange=Makie.automatic,
        linestyle=Makie.theme(scene, :linestyle),
        linewidth=Makie.theme(scene, :linewidth),
        visible=Makie.theme(scene, :visible),
        marker=Makie.theme(scene, :marker),
        markercolor=Makie.theme(scene, :markercolor),
        markercolormap=Makie.theme(scene, :colormap),
        markercolorrange=Makie.automatic,
        markersize=Makie.theme(scene, :markersize),
        markervisible=Makie.theme(scene, :visible),
        strokecolor=Makie.theme(scene, :markerstrokecolor),
        strokewidth=Makie.theme(scene, :markerstrokewidth),
        deviation=Makie.Observable(true),
        barswhiskerwidth=0,
        barscolor=Makie.theme(scene, :linecolor),
        barscolormap=Makie.theme(scene, :colormap),
        barscolorrange=Makie.automatic,
        barslinewidth=Makie.theme(scene, :linewidth),
        barsvisible=Makie.theme(scene, :visible),
        cycle=[:color],
        inspectable=Makie.theme(scene, :inspectable),
    )
end

"""
    reliability(
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
       reliability(probabilities, outcomes);

julia> # custom options: without consistency bars
       reliability(probabilities, outcomes; consistencybars=nothing);
```

See also: [`EqualMass`](@ref), [`EqualSize`](@ref), [`ConsistencyBars`](@ref)
"""
reliability(::AbstractVector{<:Real}, ::AbstractVector{Bool})

## Conversions

# without consistency bounds
function Makie.convert_arguments(
    ::Type{<:Reliability},
    probabilities::AbstractVector{<:Real},
    frequencies::AbstractVector{<:Real},
)
    points = map(probabilities, frequencies) do x, y
        return Makie.Point4f(x, y, NaN32, NaN32)
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
        return Makie.Point4f(x, y, low, high)
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
        return Makie.Point4f(x, y, low, high)
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
    meanprobabilities, meanfrequencies, low_high = ReliabilityDiagrams.means_and_bars(
        probabilities, outcomes; binning=binning, consistencybars=consistencybars
    )
    return Makie.convert_arguments(P, meanprobabilities, meanfrequencies, low_high)
end

## Plotting

# workaround to set default labels (inspired by implementation of `rainclouds`)
function Makie.plot!(
    ax::Makie.Axis, ::Type{R}, attrs::Makie.Attributes, args...; kwargs...
) where {R<:Reliability}
    # Copied from the default implementation in
    # https://github.com/MakieOrg/Makie.jl/blob/03fb7ac6096447341006d454982cbee25238e7fb/src/makielayout/blocks/axis.jl#L764
    allattrs = merge(attrs, Makie.Attributes(kwargs))
    Makie._disallow_keyword(:axis, allattrs)
    Makie._disallow_keyword(:figure, allattrs)
    cycle = Makie.get_cycle_for_plottype(allattrs, R)
    Makie.add_cycle_attributes!(allattrs, R, cycle, ax.cycler, ax.palette)

    # Create plot
    plot = Makie.plot!(ax.scene, R, allattrs, args...)

    # Set labels: If not provided, use default values
    if haskey(allattrs, :xlabel)
        ax.xlabel = allattrs.xlabel[]
    else
        ax.xlabel = "confidence"
    end
    if haskey(allattrs, :ylabel)
        ax.ylabel = allattrs.ylabel[]
    else
        Makie.on(plot.attributes.deviation) do deviation
            ax.ylabel = deviation === true ? "empirical deviation" : "empirical frequency"
        end
        Makie.notify(plot.attributes.deviation)
    end

    # Readjust limits
    Makie.reset_limits!(ax)

    return plot
end

function Makie.plot!(plot::Reliability)
    # extract
    x_y_low_high = plot.x_y_low_high
    deviation = plot.deviation

    # compute pairs of mean predictions and (deviations of) mean outcomes
    x_y = Makie.lift(x_y_low_high, deviation) do x_y_low_high, deviation
        return map(x_y_low_high) do (x, y, _, _)
            return deviation ? Makie.Point2f(x, y - x) : Makie.Point2f(x, y)
        end
    end

    # compute pairs of mean predictions and (deviations of) consistency bounds
    x_low_high = Makie.lift(x_y_low_high, deviation) do x_y_low_high, deviation
        return map(x_y_low_high) do (x, _, low, high)
            return if deviation
                Makie.Point3f(x, low - x, high - x)
            else
                Makie.Point3f(x, low, high)
            end
        end
    end

    # plot lines
    Makie.lines!(
        plot,
        x_y;
        color=plot.color,
        colormap=plot.colormap,
        colorrange=plot.colorrange,
        linestyle=plot.linestyle,
        linewidth=plot.linewidth,
        visible=plot.visible,
    )

    # plot consistency bars
    Makie.rangebars!(
        plot,
        x_low_high;
        color=plot.barscolor,
        colormap=plot.barscolormap,
        linewidth=plot.barslinewidth,
        visible=plot.barsvisible,
        whiskerwidth=plot.barswhiskerwidth,
    )

    # plot points
    Makie.scatter!(
        plot,
        x_y;
        color=plot.markercolor,
        colormap=plot.colormap,
        colorrange=plot.colorrange,
        marker=plot.marker,
        markersize=plot.markersize,
        strokecolor=plot.strokecolor,
        strokewidth=plot.strokewidth,
        visible=plot.markervisible,
    )

    return plot
end

end # module
