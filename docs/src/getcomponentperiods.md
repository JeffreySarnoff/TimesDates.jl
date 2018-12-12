## Components of Time Periods

```julia
julia> using TimesDates, Dates

julia> timedate = TimeDate("2018-03-09T18:29:34.04296875")
2018-03-09T18:29:34.04296875

julia> Month(timedate), Microsecond(timedate)
(3 months, 968 microseconds)

julia> month(timedate), microsecond(timedate)
(3, 968)

julia> yearmonthday(timedate)
(2018, 3, 9)
```

