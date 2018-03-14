> _this package requires Julia v0.7-_

- the type `TimeDate` works with DateTime, Date & Time (Dates.jl)

- the type `TimeDateZone` works with ZonedDateTime, TimeZone (TimeZones.jl)

## Setup

```julia
using Pkg3
add TimesDates
```
or
```julia
using Pkg
add("TimesDates")
```

## In Use

#### `TimeDate` is nanosecond resolved

```julia
julia> using TimesDates, Dates

julia> td2018 = TimeDate("2018-01-01T00:00:00.000000001")
2018-01-01T00:00:00.000000001

julia> td2017 = TimeDate("2018-01-01T00:00:00") - Nanosecond(1)
2017-12-31T23:59:59.999999999

julia> td2017 < td2018
true

julia> td2018 - td2018
2 nanoseconds
```

----

#### `TimeDateZone` is nanosecond resolved and zone situated

```julia
julia> using Dates, TimeZones, TimesDates

julia> zdt = ZonedDateTime(DateTime(2012,1,21,15,25,45), tz"America/Chicago")
2012-01-21T15:25:45-06:00

julia> tdz = TimeDateZone(zdt)
2012-01-21T21:25:45 America/Chicago

julia> tdz += Nanosecond(123456)
2012-01-21T21:25:45.000123456 America/Chicago

julia> ZonedDateTime(tdz)
2012-01-21T21:25:45-06:00
```
