#### TimesDates.jl: work with nanosecond resolved times.

- the types play very well together and with others
- the calculations defer to those of Dates, TimeZones
- the perspective is already familiar, and easy to use

----

| this type is like  |  a more finely resolved  |
|:-------------------|:------------------------:|
|                    |                          |
| TimeDate           | Dates.DateTime           |
|                    |                          |
| TimeDateZone       | TimeZones.ZonedDateTime  |
|                    |                          |



----

The [README](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/README.md) provides an introduction with utilitarian examples and a note on the design.

A good guide to transparent work with Dates and TimeZones is provided by the [test file](https://github.com/JeffreySarnoff/TimesDates.jl/blob/master/test/runtests.jl).
