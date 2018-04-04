-----

>>> __this will be the repository__
  
>>>  at the moment, I am simplifying, restructuring in JeffreySarnoff/NanoTimes.jl

>>>   __that will be used to replace specifics here__  

-----
-----


# TimesDates
### Nanosecond Resolvable Times with Dates, or Times with Dates in TimeZones.
#### Released under the MIT License. Copyright &copy; 2018 by Jeffrey Sarnoff.

> _this package requires Julia v0.7-_

- the type `TimeDate` works with DateTime, Date & Time (Dates.jl)

- the type `TimeDateZone` works with ZonedDateTime, TimeZone (TimeZones.jl)

----

## Types

- ### [`TimeDate`](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#timedate-is-nanosecond-resolved)

- ### [`TimeDateZone`](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#timedatezone-is-nanosecond-resolved-and-zone-situated)

----

## Examples

- ### [get components](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#get-components-1)

- ### [interconvert](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#interconvert-1)

- ### [parse times with timezones](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#parse-times-with-timezones-1)

- ### [adjust with precision](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#adjust-with-precision)

- ### [set the default timezone](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#get-and-set-the-default-timezone)

- ### [localtime() and utime()](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#use-localtime-and-utime)
----


----

## [design notes](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#the-design)

### [Setup](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#setup)

### [Acknowledgments](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md#acknowledgements)

----

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

julia> td2018 - td2017
2 nanoseconds
```

----

#### `TimeDateZone` is nanosecond resolved and zone situated

```julia
julia> using Dates, TimeZones, TimesDates

julia> zdt = ZonedDateTime(DateTime(2012,1,21,15,25,45), tz"America/Chicago")
2012-01-21T15:25:45-06:00

julia> tdz = TimeDateZone(zdt)
2012-01-21T21:25:45-06:00

julia> tdz += Nanosecond(123456)
2012-01-21T21:25:45.000123456-06:00

julia> ZonedDateTime(tdz)
2012-01-21T15:25:45-06:00
```

### Additional Examples

#### get components
```julia
julia> using Dates, TimesDates

julia> timedate = TimeDate("2018-03-09T18:29:34.04296875")
2018-03-09T18:29:34.04296875

julia> Month(timedate), Microsecond(timedate)
(3 months, 968 microseconds)

julia> month(timedate), microsecond(timedate)
(3, 968)
```
#### interconvert
```julia
julia> using Dates, TimesDates

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
#### parse times with timezones
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

#### adjust with precision
```julia
julia> using Dates, TimesDates

julia> datetime = DateTime("2001-05-10T23:59:59.999")
2001-05-10T23:59:59.999

julia-> timedate = TimeDate(datetime)
2001-05-10T23:59:59.999

julia> timedate = TimeDate(datetime, Millisecond(1)+Nanosecond(1))
2001-05-10T00:00:00.000000001
```
#### get and set the default timezone
Without this setting, UTC is used as the default.
```julia
julia> using Dates, TimeZones, TimesDates

julia> tzdefault()
UTC

julia> tzdefault!(localzone()); tzdefault()
America/New_York (UTC-5/UTC-4)

julia> tzdefault!(tz"Europe/London"); tzdefault()
Europe/London (UTC+0/UTC+1)
```
#### use `localtime` and `utime`
```julia
julia> using Dates, TimeZones, TimesDates

julia-0.7> tzdefault!(localzone())
America/New_York (UTC-5/UTC-4)

julia-0.7> localtime()
2018-04-04T13:00:30.525-04:00

julia-0.7> utime()
2018-04-04T13:00:30.545Z

julia-0.7> localtime(TimeDate), localtime(TimeDateZone)
(2018-04-04T09:00:30.549, 2018-04-04T13:00:30.549-04:00)

julia-0.7> utime(TimeDate), utime(TimeDateZone)
(2018-04-04T13:00:30.659, 2018-04-04T13:00:30.659Z)

julia-0.7> dtm = now() - Month(7) - Minute(55)
2017-09-04T08:05:30.66



julia> localtime(dtm)
2017-08-15T13:55:30.491-04:00

julia> utime(dtm)
2017-08-15T17:55:30.491+00:00
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

tbd [About TimesDates](https://jeffreysarnoff.github.io/TimesDates.jl/)


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



## Acknowledgements

This work is built atop `Dates` and `TimeZones`.
While both are collaborative works, a few people deserve mention:
- `Dates`: Jacob Quinn and Stefan Karpinski
- `TimeZones`: Curtis Vogt


## Comments and Pull Requests are welcomed

http://github.com/JeffreySarnoff/TimesDates.jl


