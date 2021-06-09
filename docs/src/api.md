# API

## Diagrams

### Makie

```@docs
reliability
```

#### Example

```@example makie
using ReliabilityDiagrams
using CairoMakie
using Random: Random # hide
Random.seed!(1) # hide

probabilities = rand(100)
outcomes = rand(100) .< probabilities
reliability(probabilities, outcomes)
save("reliability_example.svg", current_figure()); nothing # hide
```

![reliability example](reliability_example.svg)

```@example makie
lines([0, 1], [0, 1])
reliability!(probabilities, outcomes; deviation=false)
save("reliability_example_nodeviation.svg", current_figure()); nothing # hide
```

![reliability example nodeviation](reliability_example_nodeviation.svg)

```@example makie
reliability(probabilities, outcomes; consistencybars=nothing)
save("reliability_example_noconsistencybars.svg", current_figure()); nothing # hide
```

![reliability example noconsistencybars](reliability_example_noconsistencybars.svg)

```@example makie
reliability(probabilities, outcomes; binning=EqualSize())
save("reliability_example_equalsize.svg", current_figure()); nothing # hide
```

![reliability example equalsize](reliability_example_equalsize.svg)

### Plots

```@docs
reliabilityplot
```

#### Example

```@example plots
using ReliabilityDiagrams
using Plots
using Random: Random # hide
Random.seed!(1) # hide

probabilities = rand(100)
outcomes = rand(100) .< probabilities
reliabilityplot(probabilities, outcomes)
savefig("reliabilityplot_example.svg"); nothing # hide
```

![reliabilityplot example](reliabilityplot_example.svg)

```@example plots
plot([0, 1], [0, 1])
reliabilityplot!(probabilities, outcomes; deviation=false)
savefig("reliabilityplot_example_nodeviation.svg"); nothing # hide
```

![reliabilityplot example nodeviation](reliabilityplot_example_nodeviation.svg)

```@example plots
reliabilityplot(probabilities, outcomes; consistencybars=nothing)
savefig("reliabilityplot_example_noconsistencybars.svg"); nothing # hide
```

![reliabilityplot example noconsistencybars](reliabilityplot_example_noconsistencybars.svg)

```@example plots
reliabilityplot(probabilities, outcomes; binning=EqualSize())
savefig("reliabilityplot_example_equalsize.svg"); nothing # hide
```

![reliabilityplot example equalsize](reliabilityplot_example_equalsize.svg)

## Binning algorithms

```@docs
EqualMass
EqualSize
```

## Consistency bars

```@docs
ConsistencyBars
```