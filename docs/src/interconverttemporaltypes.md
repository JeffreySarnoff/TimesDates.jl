## Temporal Type Interconversion

```julia
julia> using TimesDates, Dates

julia> date = Date("2011-02-05")
2011-02-05

julia> timedate = TimeDate(date); timedate, Date(timedate)
(2011-02-05T00:00:00, 2011-02-05)

julia> datetime = DateTime("2011-02-05T11:22:33")
2011-02-05T11:22:33

julia> timedate = TimeDate(datetime);
julia> timedate, DateTime(timedate)
(2011-02-05T11:22:33, 2011-02-05T11:22:33)
```
