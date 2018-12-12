This package provides `TimeDate` to hold the date and time of day given in nanoseconds (or more coarsely).
And provides`TimeDateZone` to holds the the date and time of day in nanoseconds with a timezone.
This work relies heavily on `Dates` and `TimeZones`; most of the attention to detail plays through.

`Dates` has a `Time` type that has nanosecond resolution; it is not well supported, even within `Dates`.
This `Time` type recognizes strings only if they are limited to millisecond resolution.
Only millisecond resolved times are relevant to `DateTime`s.
While at present limited by this millisecond barrier, `TimeZones` is a laudable package with active support.
I expect an eventual melding of what's best.


Here, the inner dynamics rely upon the `Period` types (`Year` .. `Day`, `Hour`, .., `Nanosecond`) and
`CompoundPeriod` all provided by `Dates`.
We distinguish _slowtime_, which is millisecond resolved, from a nanosecond resolved _fasttime_.

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

The general approach is separate the date, slowtime, fasttime, and timezone (if appropriate),
then use the date, slowtime and timezone (if appropriate) to obtain a coarse result
using the facilities provided by the `Date` and `TimeZones` packages.
We refine the coarse result by adding or subtracting the fasttime, as appropriate.
