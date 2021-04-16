using Documenter

# Print `@debug` statements (https://github.com/JuliaDocs/Documenter.jl/issues/955)
if haskey(ENV, "GITHUB_ACTIONS")
    ENV["JULIA_DEBUG"] = "Documenter"
end

using ReliabilityDiagrams

DocMeta.setdocmeta!(
    ReliabilityDiagrams, :DocTestSetup, :(using ReliabilityDiagrams); recursive=true
)

makedocs(;
    modules=[ReliabilityDiagrams],
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
