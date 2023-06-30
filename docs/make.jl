using ReliabilityDiagrams
using Documenter

# Load weak dependencies (otherwise modules below cannot be loaded)
using CairoMakie
using Plots

# Extensions
const ReliabilityDiagramsMakieExt = if isdefined(Base, :get_extension)
    Base.get_extension(ReliabilityDiagrams, :ReliabilityDiagramsMakieExt)
else
    ReliabilityDiagrams.ReliabilityDiagramsMakieExt
end
const ReliabilityDiagramsRecipesBaseExt = if isdefined(Base, :get_extension)
    Base.get_extension(ReliabilityDiagrams, :ReliabilityDiagramsRecipesBaseExt)
else
    ReliabilityDiagrams.ReliabilityDiagramsRecipesBaseExt
end

# Import statements for doctests
DocMeta.setdocmeta!(
    ReliabilityDiagramsMakieExt,
    :DocTestSetup,
    quote
        using ReliabilityDiagrams
        using CairoMakie
    end;
    recursive=true,
)
DocMeta.setdocmeta!(
    ReliabilityDiagramsRecipesBaseExt,
    :DocTestSetup,
    quote
        using ReliabilityDiagrams
        using Plots
    end;
    recursive=true,
)

# Build docs and run doctests
makedocs(;
    # Workaround for https://github.com/JuliaDocs/Documenter.jl/issues/2124
    modules=[
        ReliabilityDiagrams, ReliabilityDiagramsMakieExt, ReliabilityDiagramsRecipesBaseExt
    ],
    authors="David Widmann",
    repo="https://github.com/devmotion/ReliabilityDiagrams.jl/blob/{commit}{path}#{line}",
    sitename="ReliabilityDiagrams.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://devmotion.github.io/ReliabilityDiagrams.jl",
        assets=String[],
    ),
    pages=["Home" => "index.md", "api.md"],
    #strict=true,
    checkdocs=:exports,
)

# Deploy docs on Github
deploydocs(;
    repo="github.com/devmotion/ReliabilityDiagrams.jl", push_preview=true, devbranch="main"
)
