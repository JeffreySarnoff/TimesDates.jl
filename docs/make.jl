using Documenter, TimesDates, CompoundPeriods, Dates

makedocs(
    modules = [TimesDates],
    sitename = "TimesDates",
    pages  = Any[
        "Overview"                     => "index.md",
        "Setup"                        => "setup.md",
        "Types"                        => "timedate_zone.md",
        "Dydactic Examples"            => "dydacticexamples.md",
        "Design Notes"                 => "designnotes.md",
        "Acknowledgements"             => "acknowledgements.md"
        ]
    )

deploydocs(
    repo = "github.com/JeffreySarnoff/TimesDates.jl.git",
    target = "build"
)
