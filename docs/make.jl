using Documenter, TimesDates, CompoundPeriods, Dates

makedocs(
    modules = [TimesDates],
    sitename = "TimesDates",
    pages  = Any[
        "Overview"                 => "index.md",
        "References"               => "references.md",
        "Index"                    => "documentindex.md"
        ]
    )

deploydocs(
    repo = "github.com/JeffreySarnoff/TimesDates.jl.git",
    target = "build"
)
