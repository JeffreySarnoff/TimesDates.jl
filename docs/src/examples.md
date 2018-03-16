

Get components.
```julia
julia> using Dates, TimesDates

julia> timedate = TimeDate("2018-03-09T18:29:34.04296875")
2018-03-09T18:29:34.04296875

julia> Month(timedate), Microsecond(timedate)
(3 months, 968 microseconds)

julia> month(timedate), microsecond(timedate)
(3, 968)
```
Interconvert.
```julia
julia> using Dates, TimesDates

julia> date = Date("2011-02-05")
2011-02-05

julia> timedate = TimeDate(date); timedate, Date(timedate)
(2011-02-05T00:00:00, 2011-02-05)

julia> datetime = DateTime("2011-02-05T11:22:33")
2011-02-05T11:22:33

julia> timedate = TimeDate(datetime); timedate, DateTime(timedate)
(2011-02-05T11:22:33, 2011-02-05T11:22:33)
```
Get and Set the timezone to be used when no zone is specified.
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
Use `localtime` and `utime`.
```julia
julia> using Dates, TimeZones, TimesDates

julia> tzdefault!(localzone())
America/New_York (UTC-5/UTC-4)

julia> localtime()
2018-03-15T14:50:28.719-04:00

julia> utime()
2018-03-15T18:50:30.282+00:00

julia> localtime(TimeDate), localtime(TimeDateZone)
(2018-03-15T14:50:30.291, 2018-03-15T14:50:30.294-04:00)

julia> utime(TimeDate), utime(TimeDateZone)
(2018-03-15T18:50:30.484, 2018-03-15T18:50:30.489+00:00)

julia> dtm = now() - Month(7) - Minute(55)
2017-08-15T13:55:30.491

julia> localtime(dtm)
2017-08-15T13:55:30.491-04:00

julia> utime(dtm)
2017-08-15T17:55:30.491+00:00
```


## The Design

`Dates` has a `Time` type that has nanosecond resolution; it is not well supported, even within `Dates`.  This `Time` type recognizes strings only if they are limited to millisecond resolution.  It does form strings with nanosecond resolution.  This situation is exacerbated with the `DateTime` type.  Only millisecond (or coarser) resolved times are `DateTime` useful.

`TimeZones` is a laudable package.  At present it is limited by the millisecond barrier that accompanies `DateTime`.

This package exists to provide the community with two types.  One type `TimeDate` holds the caledar date with the time of day in nanoseconds.  The other `TimeDateZone` holds the the caledar date with the time of day in nanoseconds and the timezone.

The inner dynamics rely upon the `Period` types (`Year` .. `Day`, `Hour`, .., `Nanosecond`) and `CompoundPeriod` all provided by `Dates`.  We distinguish _slowtime_, which is millisecond resolved, from a nanosecond resolved _fasttime_.

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
