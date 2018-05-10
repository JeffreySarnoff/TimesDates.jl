#### TimesDates.jl: work with nanosecond resolved times.

- the types play very well together and with others
- the calculations defer to those of Dates, TimeZones
- the perspective is already familiar, and easy to use

----

|                     |                           |
|:--------------------|:-------------------------:|
| _this type is like_ |  _a more finely resolved_ |
| TimeDate            | Dates.DateTime            |
|                     |                           |
| TimeDateZone        | TimeZones.ZonedDateTime   |
|                     |                           |

----

#### install

This package requires Julia v0.7-, please run Pkg.update() first.
```
using Pkg; Pkg.add("TimesDates")
using TimesDates, TimeZones, Dates
````

----

The [README](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md) provides an introduction with utilitarian examples and a note on the design.

A good guide to transparent work with Dates and TimeZones is provided by the [test file](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/test/runtests.jl).
