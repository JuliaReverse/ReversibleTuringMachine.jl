using Documenter, ReversibleTuringMachine

makedocs(;
    modules=[ReversibleTuringMachine],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/JuliaReverse/ReversibleTuringMachine.jl/blob/{commit}{path}#L{line}",
    sitename="ReversibleTuringMachine.jl",
    authors="JuliaReverse",
    assets=String[],
)

deploydocs(;
    repo="github.com/JuliaReverse/ReversibleTuringMachine.jl",
)
