var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/#Diagrams","page":"API","title":"Diagrams","text":"","category":"section"},{"location":"api/#Makie","page":"API","title":"Makie","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"reliability","category":"page"},{"location":"api/#ReliabilityDiagrams.reliability","page":"API","title":"ReliabilityDiagrams.reliability","text":"reliability(probabilities, frequencies; deviation=true, kwargs...)\nreliability(probfreqs::AbstractVector{Point2f0}; deviation=true, kwargs...)\n\nPlot a reliability diagram of the observed frequencies versus the predicted probabilities.\n\nIf deviation is true (default), the difference frequencies - probabilities is  plotted versus probabilities. This can be helpful for inspecting how closely the observed frequencies match the predicted probabilities.\n\nAttributes\n\nAvailable attributes and their defaults for AbstractPlotting.Combined{ReliabilityDiagrams.reliability, T} where T are: \n\n  color             :black\n  colormap          :viridis\n  colorrange        AbstractPlotting.Automatic()\n  deviation         true\n  linestyle         \"nothing\"\n  linewidth         1.0\n  marker            GeometryBasics.Circle{T} where T\n  markercolor       :gray65\n  markercolormap    :viridis\n  markercolorrange  AbstractPlotting.Automatic()\n  markersize        10\n  markervisible     true\n  strokecolor       :black\n  strokewidth       1.0\n\n\n\n\n\nreliability(probabilities, outcomes, algorithm; kwargs...)\n\nUse the algorithm to form clusters of predicted probabilities and corresponding outcomes, and plot a reliability diagram of the observed frequencies versus the mean probabilities in each cluster.\n\n\n\n\n\n","category":"function"},{"location":"api/#Example","page":"API","title":"Example","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"using ReliabilityDiagrams\nusing CairoMakie\nusing Random: Random # hide\nRandom.seed!(1) # hide\n\nprobabilities = rand(100)\noutcomes = rand(100) .< probabilities\nreliability(probabilities, outcomes, EqualMass(10); color=:blue)\nsave(\"reliability_example.svg\", current_figure()); nothing # hide","category":"page"},{"location":"api/","page":"API","title":"API","text":"(Image: reliability example)","category":"page"},{"location":"api/","page":"API","title":"API","text":"lines([0, 1], [0, 1])\nreliability!(probabilities, outcomes, EqualMass(10); color=:blue, deviation=false)\nsave(\"reliability_example_nodeviation.svg\", current_figure()); nothing # hide","category":"page"},{"location":"api/","page":"API","title":"API","text":"(Image: reliability example nodeviation)","category":"page"},{"location":"api/","page":"API","title":"API","text":"reliability(probabilities, outcomes, EqualSize(10); markercolor=:red)\nsave(\"reliability_example_equalsize.svg\", current_figure()); nothing # hide","category":"page"},{"location":"api/","page":"API","title":"API","text":"(Image: reliability example equalsize)","category":"page"},{"location":"api/#Plots","page":"API","title":"Plots","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"reliabilityplot","category":"page"},{"location":"api/#ReliabilityDiagrams.reliabilityplot","page":"API","title":"ReliabilityDiagrams.reliabilityplot","text":"reliabilityplot(probabilities, frequencies; deviation=true, kwargs...)\n\nPlot a reliability diagram of the observed frequencies versus the predicted probabilities.\n\nIf deviation is true (default), the difference frequencies - probabilities is plotted versus probabilities. This can be helpful for inspecting how closely the observed frequencies match the predicted probabilities.\n\n\n\n\n\nreliabilityplot(probabilities, outcomes, algorithm; kwargs...)\n\nUse the algorithm to form clusters of predicted probabilities and corresponding outcomes, and plot a reliability diagram of the observed frequencies versus the mean probabilities in each cluster.\n\n\n\n\n\n","category":"function"},{"location":"api/#Example-2","page":"API","title":"Example","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"using ReliabilityDiagrams\nusing Plots\nusing Random: Random # hide\nRandom.seed!(1) # hide\n\nprobabilities = rand(100)\noutcomes = rand(100) .< probabilities\nreliabilityplot(probabilities, outcomes, EqualMass(10); color=:blue)\nsavefig(\"reliabilityplot_example.svg\"); nothing # hide","category":"page"},{"location":"api/","page":"API","title":"API","text":"(Image: reliabilityplot example)","category":"page"},{"location":"api/","page":"API","title":"API","text":"plot([0, 1], [0, 1])\nreliabilityplot!(probabilities, outcomes, EqualMass(10); color=:blue, deviation=false)\nsavefig(\"reliabilityplot_example_nodeviation.svg\"); nothing # hide","category":"page"},{"location":"api/","page":"API","title":"API","text":"(Image: reliabilityplot example nodeviation)","category":"page"},{"location":"api/","page":"API","title":"API","text":"reliabilityplot(probabilities, outcomes, EqualSize(10); markercolor=:red)\nsavefig(\"reliabilityplot_example_equalsize.svg\"); nothing # hide","category":"page"},{"location":"api/","page":"API","title":"API","text":"(Image: reliabilityplot example equalsize)","category":"page"},{"location":"api/#Binning-algorithms","page":"API","title":"Binning algorithms","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"EqualMass\nEqualSize","category":"page"},{"location":"api/#ReliabilityDiagrams.EqualMass","page":"API","title":"ReliabilityDiagrams.EqualMass","text":"EqualMass(n::Int)\n\nCreate binning algorithm with n bins of (approximately) equal number of probabilities.\n\n\n\n\n\n","category":"type"},{"location":"api/#ReliabilityDiagrams.EqualSize","page":"API","title":"ReliabilityDiagrams.EqualSize","text":"EqualSize(n::Int)\n\nCreate binning algorithm of the probability simplex with n bins of the same size.\n\n\n\n\n\n","category":"type"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = ReliabilityDiagrams","category":"page"},{"location":"#ReliabilityDiagrams","page":"Home","title":"ReliabilityDiagrams","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Visualization of model calibration","category":"page"}]
}
