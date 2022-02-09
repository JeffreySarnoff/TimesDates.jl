#### install

This package expects Julia v1.6 or higher
```julia
julia> using Pkg
julia> Pkg.update()
julia> Pkg.add("TimeZones"); Pkg.build("TimeZones")
julia> Pkg.add(["CompoundPeriods", "TimesDates"])
```

#### use

```julia
using TimesDates, CompoundPeriods, TimeZones, Dates
```


