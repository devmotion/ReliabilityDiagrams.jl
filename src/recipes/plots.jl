"""
    reliabilityplot(probabilities, frequencies; deviation=true, kwargs...)

Plot a reliability diagram of the observed `frequencies` versus the predicted
`probabilities`.

If `deviation` is `true` (default), the difference `frequencies - probabilities` is
plotted versus `probabilities`. This can be helpful for inspecting how closely the
observed frequencies match the predicted probabilities.
"""
RecipesBase.@userplot struct ReliabilityPlot{X<:AbstractVector,Y<:AbstractVector}
    probs::X
    freqs::Y
end

# default constructor (recipe forwards arguments as tuple)
function ReliabilityPlot(
    (probabilities, frequencies)::Tuple{<:AbstractVector{<:Real},<:AbstractVector{<:Real}}
)
    return ReliabilityPlot(probabilities, frequencies)
end

"""
    reliabilityplot(probabilities, outcomes, algorithm; kwargs...)

Use the `algorithm` to form clusters of predicted probabilities and corresponding outcomes,
and plot a reliability diagram of the observed frequencies versus the mean probabilities
in each cluster.
"""
reliabilityplot(::AbstractVector{<:Real}, ::AbstractVector{Bool}, ::Any; kwargs...)

RecipesBase.@recipe function f(plot::ReliabilityPlot)
    deviation::Bool = get(plotattributes, :deviation, true)

    x = plot.probs
    y = plot.freqs
    _y = deviation ? y - x : y - zero(x)

    # default attributes
    seriestype --> :line
    markershape --> :circle

    return x, _y
end
