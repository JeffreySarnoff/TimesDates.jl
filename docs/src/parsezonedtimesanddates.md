## Parsing Zoned Dates and Times

```julia
julia> using TimesDates, TimeZones, Dates

julia> datetime = DateTime("2011-05-08T12:11:15.050");
julia> zdt = ZonedDateTime(datetime, tz"Australia/Sydney")
2011-05-08T12:11:15.05+10:00

julia> tdz = TimeDateZone(zdt)
2011-05-08T02:11:15.05+10:00

julia> tdz += Microsecond(11)
2011-05-08T02:11:15.050011+10:00

julia> string(tdz)
"2011-05-08T02:11:15.050011+10:00"

julia> TimeDateZone(string(tdz))
2011-05-08T02:11:15.050011+10:00

julia> string(tdz, tzname=true)
"2011-05-08T02:11:15.050011 Australia/Sydney"

julia> TimeDateZone(string(tdz, tzname=true))
2011-05-07T16:11:15.050011+10:00
```
