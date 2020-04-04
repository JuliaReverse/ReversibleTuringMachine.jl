using Documenter, ReversibleTuringMachine

makedocs(;
    modules=[ReversibleTuringMachine],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/GiggleLiu/ReversibleTuringMachine.jl/blob/{commit}{path}#L{line}",
    sitename="ReversibleTuringMachine.jl",
    authors="GiggleLiu",
    assets=String[],
)

deploydocs(;
    repo="github.com/GiggleLiu/ReversibleTuringMachine.jl",
)
