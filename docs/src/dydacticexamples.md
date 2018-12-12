# Examples

## Comprised of Time Periods

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

## Relative Dates and Days

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
