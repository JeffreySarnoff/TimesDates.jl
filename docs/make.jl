using Dates, TimeZones, TimesDates, Documenter

makedocs(
    modules = [TimesDates],
    clean = false,
    format = :html,
    sitename = "TimesDates.jl",
    authors = "Jeffrey Sarnoff",
    pages = [
        "Home" => "index.md",
        "Overview" => "overview.md",
        "Examples" => "examples.md"
    ],
)

deploydocs(
    julia = "nightly",
    repo = "github.com/JeffreySarnoff/TimesDates.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
)
