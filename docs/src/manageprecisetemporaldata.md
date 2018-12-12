## Precision Time Management

```julia
julia> using TimesDates, Dates

julia> datetime = DateTime("2001-05-10T23:59:59.999")
2001-05-10T23:59:59.999

julia-> timedate = TimeDate(datetime)
2001-05-10T23:59:59.999

julia> timedate += Millisecond(1) + Nanosecond(1)
2001-05-10T00:00:00.000000001
```

