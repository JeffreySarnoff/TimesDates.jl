# TimesDates
### Nanosecond Resolvable Times with Dates, or Times with Dates in TimeZones.

----

#### Copyright ©&thinsp;2018 by Jeffrey Sarnoff. &nbsp;&nbsp; This work is made available under The MIT License.


-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/TimesDates.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/TimesDates.jl)&nbsp;&nbsp;&nbsp;[![Docs Stable](https://img.shields.io/badge/docs-stable-blue.svg)](http://jeffreysarnoff.github.io/TimesDates.jl)

  
----


## Setup

#### install

This package expects Julia v1 (v0.7 is allowed)
```julia
pkg> up
pkg> add TimeZones
pkg> add CompoundPeriods
pkg> add TimesDates
pkg> precompile
````

#### use

```julia
using TimesDates, CompoundPeriods, TimeZones, Dates
````

-----

### TimeDate
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

### TimeDateZone
- nanoseconds and microseconds are understood
- intrazone and interzone relationships hold
- ISO timestamps and Zoned timestamps available

```julia
julia> using TimesDates, TimeZones, Dates

julia> zdt = ZonedDateTime(DateTime(2012,1,21,15,25,45), tz"America/Chicago")
2012-01-21T15:25:45-06:00

julia> tdz = TimeDateZone(zdt)
2012-01-21T21:25:45-06:00

julia> tdz += Nanosecond(123456)
2012-01-21T21:25:45.000123456-06:00

julia> ZonedDateTime(tdz)
2012-01-21T15:25:45-06:00
```



-----


|  __Examples of Use__   |
|--------------------|
| [get component periods](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#get-component-periods) |
| [get relative dates](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#get-relative-dates) |
| [interconvert temporal types](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#interconvert-temporal-types) |
| [parse zoned times and dates](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#parse-zoned-times-and-dates) |
| [manage temporal data more precisely](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#manage-temporal-data-more-precisely) |

----

### Additional Examples

#### get component periods

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

#### get relative dates

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

#### interconvert temporal types

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

#### parse zoned times and dates

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

#### manage temporal data more precisely

```julia
julia> using TimesDates, Dates

julia> datetime = DateTime("2001-05-10T23:59:59.999")
2001-05-10T23:59:59.999

julia-> timedate = TimeDate(datetime)
2001-05-10T23:59:59.999

julia> timedate += Millisecond(1) + Nanosecond(1)
2001-05-10T00:00:00.000000001
```

----

## The Design

This package provides `TimeDate` to hold the date and time of day given in nanoseconds (or more coarsely).  And provides`TimeDateZone` to holds the the date and time of day in nanoseconds with a timezone. This work relies heavily on `Dates` and `TimeZones`; most of the attention to detail plays through.

`Dates` has a `Time` type that has nanosecond resolution; it is not well supported, even within `Dates`.  This `Time` type recognizes strings only if they are limited to millisecond resolution. Only millisecond resolved times are relevant to `DateTime`s.  While at present limited by this millisecond barrier, `TimeZones` is a laudable package with active support.  I expect an eventual melding of what's best.


Here, the inner dynamics rely upon the `Period` types (`Year` .. `Day`, `Hour`, .., `Nanosecond`) and `CompoundPeriod` all provided by `Dates`.  We distinguish _slowtime_, which is millisecond resolved, from a nanosecond resolved _fasttime_.

```julia
julia> using Dates, TimesDates

julia> datetime = now()
2018-03-15T06:41:33.643

julia> currentdate = Date(datetime)
2018-03-15

julia> currenttime = Time(datetime)
06:41:33.643

julia> highrestime = currenttime + Nanosecond(98765)
06:41:33.643098765

julia> date = currentdate
2018-03-15

julia> fasttime = Microsecond(highrestime) + Nanosecond(highrestime)
98 microseconds, 765 nanoseconds

julia> slowtime = highrestime - fasttime
06:41:33.643
```

The general approach is separate the date, slowtime, fasttime, and timezone (if appropriate), then use the date, slowtime and timezone (if appropriate) to obtain a coarse result using the facilities provided by the `Date` and `TimeZones` packages.  We refine the coarse result by adding or subtracting the fasttime, as appropriate.




## Acknowledgements

This work is built atop `Dates` and `TimeZones`.
While both are collaborative works, a few people deserve mention:
- `Dates`: Jacob Quinn and Stefan Karpinski
- `TimeZones`: Curtis Vogt
- early work on timezones:  Avik Sengupta

## Comments and Pull Requests are welcomed

http://github.com/JeffreySarnoff/TimesDates.jl

