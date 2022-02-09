# TimesDates
#### Nanosecond Resolvable Times with Dates, Times in TimeZones.

----

#### Copyright ©&thinsp;2018 by Jeffrey Sarnoff. &nbsp;&nbsp; Available under The MIT License.


-----

[![Docs Latest](https://img.shields.io/badge/docs-latest-blue.svg)](http://jeffreysarnoff.github.io/TimesDates.jl/latest/)

----

## Setup

#### install

This package expects Julia v1.6.3 or higher
```julia
pkg> up
pkg> add TimeZones CompoundPeriods TimesDates
````

#### use

```julia
using TimesDates, CompoundPeriods, TimeZones, Dates
````

## The Design

This package provides `TimeDate` to hold the date and time of day given in nanoseconds (or more coarsely).  And provides`TimeDateZone` to holds the the date and time of day in nanoseconds with a timezone. This work relies heavily on `Dates` and `TimeZones`; most of the attention to detail plays through.

`Dates` has a `Time` type that has nanosecond resolution; it is not well supported, even within `Dates`.  This `Time` type recognizes strings only if they are limited to millisecond resolution. Only millisecond resolved times are relevant to `DateTime`s.  While at present limited by this millisecond barrier, `TimeZones` is a laudable package with active support.  I expect an eventual melding of what's best.

Here, the inner dynamics rely upon the `Period` types (`Year` .. `Day`, `Hour`, .., `Nanosecond`) and `CompoundPeriod` all provided by `Dates`.  We distinguish _slowtime_, which is millisecond resolved, from a nanosecond resolved _fasttime_.

The general approach is separate the date, slowtime, fasttime, and timezone (if appropriate), then use the date, slowtime and timezone (if appropriate) to obtain a coarse result using the facilities provided by the `Date` and `TimeZones` packages.  We refine the coarse result by adding or subtracting the fasttime, as appropriate.


## Acknowledgements

This work is built atop `Dates` and `TimeZones`.

While both are collaborative works, a few people deserve mention:
- `Dates`: Jacob Quinn and Stefan Karpinski
- `TimeZones`: Curtis Vogt
- early work on timezones:  Avik Sengupta

