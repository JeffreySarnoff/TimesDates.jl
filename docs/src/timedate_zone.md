# Types

## TimeDate

- nanoseconds and microseconds are understood
- omits the flexible formatting of DateTime
- timestamps with nanosecond resolution

```julia
julia> using TimesDates, Dates

julia> td2018 = TimeDate("2018-01-01T00:00:00.000000001")
2018-01-01T00:00:00.000000001

julia> td2017 = TimeDate("2018-01-01T00:00:00") - Nanosecond(1)
2017-12-31T23:59:59.999999999

julia> td2017 < td2018
true

julia> td2018 - td2017
2 nanoseconds

julia> TimeDate(2003,4,5,9,8,7,6,5,4)
2003-04-05T09:08:07.006005004

```

## TimeDateZone

- nanoseconds and microseconds are understood
- intrazone and interzone relationships hold
- ISO timestamps and Zoned timestamps available

```julia
julia> using TimesDates, TimeZones, Dates

#            ZonedDateTime is exported by TimeZones.jl
julia> zdt = ZonedDateTime(DateTime(2012,1,21,15,25,45), tz"America/Chicago")
2012-01-21T15:25:45-06:00

julia> tdz = TimeDateZone(zdt)
2012-01-21T21:25:45-06:00

julia> tdz += Nanosecond(123456)
2012-01-21T21:25:45.000123456-06:00

julia> ZonedDateTime(tdz)
2012-01-21T15:25:45-06:00
```
