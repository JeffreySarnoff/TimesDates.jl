# TimesDates
### Nanosecond Resolvable Times with Dates, or Times with Dates in TimeZones.
#### Released under the MIT License. Copyright &copy; 2018 by Jeffrey Sarnoff.

> _this package requires Julia v0.7-_

- _the type `TimeDate` works, and interoperates with DateTime, Date & Time

- _the type `TimeDateZone` works with ZonedDateTime, TimeZone from TimeZones.jl

## Setup

```julia
using Pkg3
add TimesDates
```

## In Use

### `TimeDate` is nanosecond resolved

```julia
julia> using TimesDates, Dates

julia> td2018 = TimeDate("2018-01-01T00:00:00") + Nanosecond(1)
2018-01-01T00:00:00.000000001

julia> td2017 = TimeDate("2018-01-01T00:00:00") - Nanosecond(1)
2017-12-31T23:59:59.999999999

julia> td2017 < td2018
true

julia> td2018 - td2018
2 nanoseconds
```

----

### `TimeDateZone` is nanosecond resolved and zone situated

```julia
julia> using TimesDates, Dates, TimeZones

julia> zdt = ZonedDateTime(DateTime(2012,1,21,15,25,45), tz"America/Chicago")
2012-01-21T15:25:45-06:00

julia> tdz = TimeDateZone(zdt)
2012-01-21T21:25:45 America/Chicago

julia> tdz += Nanosecond(123456)
2012-01-21T21:25:45.000123456 America/Chicago

julia> ZonedDateTime(tdz)
2012-01-21T21:25:45-06:00
```

### Additional Examples

```julia
julia> timedate = TimeDate("2018-03-09T18:29:34.04296875")
2018-03-09T18:29:34.04296875

julia> Month(timedate), Microsecond(timedate)
(3 months, 968 microseconds)

julia> month(timedate), microsecond(timedate)
(3, 968)
```
```julia
julia> date = Date("2011-02-05")
2011-02-05

julia> timedate = TimeDate(date); timedate, Date(timedate)
2011-02-05T00:00:00, 2011-02-05

julia> datetime = DateTime("2011-02-05T11:22:33")
2011-02-05T11:22:33

julia> timedate = TimeDate(datetime); timedate, DateTime(timedate)
2011-02-05T11:22:33, 2011-02-05T11:22:33
```

```julia
julia> # set the timezone to be used when no zone is specified
julia> #     without this setting, UTC is used as the default.
julia> tzname = "Europe/London"
julia> timezone = TimeZone(tzname)
julia> tzdefault!(timezone)
```


## Additional Information
tbd [About TimesDates](https://jeffreysarnoff.github.io/TimesDates.jl/)

## Comments are Welcomed

http://github.com/JeffreySarnoff/TimesDates.jl

