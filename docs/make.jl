using Documenter

# Print `@debug` statements (https://github.com/JuliaDocs/Documenter.jl/issues/955)
if haskey(ENV, "GITHUB_ACTIONS")
    ENV["JULIA_DEBUG"] = "Documenter"
end

using ReliabilityDiagrams

# Load weak dependencies (otherwise modules below cannot be loaded)
using CairoMakie
using Plots

DocMeta.setdocmeta!(
    ReliabilityDiagrams,
    :DocTestSetup,
    quote
        using ReliabilityDiagrams
        using CairoMakie
        using Plots
    end;
    recursive=true,
)

makedocs(;
    # Workaround for https://github.com/JuliaDocs/Documenter.jl/issues/2124
    modules=[
        ReliabilityDiagrams,
        if isdefined(Base, :get_extension)
            Base.get_extension(ReliabilityDiagrams, :ReliabilityDiagramsMakieExt)
        else
            ReliabilityDiagrams.ReliabilityDiagramsMakieExt
        end,
        if isdefined(Base, :get_extension)
            Base.get_extension(ReliabilityDiagrams, :ReliabilityDiagramsRecipesBaseExt)
        else
            ReliabilityDiagrams.ReliabilityDiagramsRecipesBaseExt
        end,
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

deploydocs(;
    repo="github.com/devmotion/ReliabilityDiagrams.jl", push_preview=true, devbranch="main"
)
