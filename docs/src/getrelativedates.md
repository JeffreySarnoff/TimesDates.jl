```julia
julia> using TimesDates, TimeZones, Dates

julia> td = TimeDate("2018-05-06T08:09:10.123456789")
2018-05-06T08:09:10.123456789

julia> tdz = TimeDateZone(td, tz"America/New_York")
2018-05-06T08:09:10.123456789-04:00

julia> firstdayofweek(td), firstdayofweek(tdz)
(2018-04-30, 2018-04-30)

julia> dayname(td)
"Sunday"

julia> td_midnight = TimeDate(Date(td))
2018-05-06T00:00:00

julia> tonext(td_midnight, Friday)
2018-05-11T00:00:00

julia> dayname(ans)
"Friday"
```
