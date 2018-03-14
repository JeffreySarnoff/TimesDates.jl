using Documenter, TimesDates

makedocs(
    modules = [TimesDates],
    clean = false,
    format = :html,
    sitename = "TimesDates.jl",
    pages = Any[
        "Home" => "index.md",
        "API" => "api.md",
        "Implementations" => "implementations.md",
    ],
)

deploydocs(
    repo = "github.com/JeffreySarnoff/TimesDates.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
)
