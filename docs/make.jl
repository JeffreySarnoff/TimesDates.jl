using Documenter, TimesDates, CompoundPeriods, Dates

makedocs(
    modules = [TimesDates],
    sitename = "TimesDates",
    pages  = Any[
        "Overview"                     => "index.md",
        "Setup"                        => "setup.md",
        "TimeDate"                     => "timedate.md",
        "TimeDateZone"                 => "timedatezone.md",
        "_Examples_"                   => "exampleindex.md",
        "Get Component Periods"        => "getcomponentperiods.md",
        "Get Relative Dates"           => "getrelativedates.md",
        "Interconvert Temporal Types"  => "interconverttemporaltypes.md",
        "Parse Zoned Times and Dates"  => "parsezonedtimesanddates.md",
        "Manage Precise Temporal Data" => "manageprecisetemporaldata.md",
        "Design Notes"                 => "designnotes.md",
        "Acknowledgements"             => "acknowledgements.md"
        ]
    )

deploydocs(
    repo = "github.com/JeffreySarnoff/TimesDates.jl.git",
    target = "build"
)
