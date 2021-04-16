"""
    reliability(probabilities, frequencies; deviation=true, kwargs...)
    reliability(probfreqs::AbstractVector{Point2f0}; deviation=true, kwargs...)

Plot a reliability diagram of the observed `frequencies` versus the predicted
`probabilities`.

If `deviation` is `true` (default), the difference `frequencies - probabilities` is 
plotted versus `probabilities`. This can be helpful for inspecting how closely the
observed frequencies match the predicted probabilities.

## Attributes

$(AbstractPlotting.ATTRIBUTES)
"""
@recipe(Reliability, xy) do scene
    l_theme = AbstractPlotting.default_theme(scene, AbstractPlotting.Lines)
    s_theme = AbstractPlotting.default_theme(scene, AbstractPlotting.Scatter)
    return Attributes(;
        color=l_theme.color,
        colormap=l_theme.colormap,
        colorrange=get(l_theme.attributes, :colorrange, AbstractPlotting.automatic),
        linestyle=l_theme.linestyle,
        linewidth=l_theme.linewidth,
        marker=s_theme.marker,
        markercolor=s_theme.color,
        markercolormap=s_theme.colormap,
        markercolorrange=get(s_theme.attributes, :colorrange, AbstractPlotting.automatic),
        markersize=s_theme.markersize,
        markervisible=Node(true),
        strokecolor=s_theme.strokecolor,
        strokewidth=s_theme.strokewidth,
        deviation=Node(true),
    )
end

"""
    reliability(probabilities, outcomes, algorithm; kwargs...)

Use the `algorithm` to form clusters of predicted probabilities and corresponding outcomes,
and plot a reliability diagram of the observed frequencies versus the mean probabilities
in each cluster.
"""
reliability(::AbstractVector{<:Real}, ::AbstractVector{Bool}, ::Any)

function AbstractPlotting.plot!(plot::Reliability)
    @extract plot (xy,)

    _xy = lift(xy, plot.deviation) do xy, deviation
        return if deviation
            map(xy) do (x, y)
                Point2f0(x, y - x)
            end
        else
            xy
        end
    end

    AbstractPlotting.lines!(
        plot,
        _xy;
        color=plot.color,
        colormap=plot.colormap,
        colorrange=plot.colorrange,
        linestyle=plot.linestyle,
        linewidth=plot.linewidth,
    )
    AbstractPlotting.scatter!(
        plot,
        _xy;
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
