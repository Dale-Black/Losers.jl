using Losers
using Documenter

DocMeta.setdocmeta!(Losers, :DocTestSetup, :(using Losers); recursive=true)

makedocs(;
    modules=[Losers],
    authors="Dale <djblack@uci.edu> and contributors",
    repo="https://github.com/Dale-Black/Losers.jl/blob/{commit}{path}#{line}",
    sitename="Losers.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Dale-Black.github.io/Losers.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Dale-Black/Losers.jl",
)
