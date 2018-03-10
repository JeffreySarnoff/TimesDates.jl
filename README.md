# TimesDates
### Nanosecond Resolvable Times with Dates, or Times with Dates in TimeZones.
### Copyright &copy; 2018 by Jeffrey Sarnoff.  Offered under the MIT License.

## Setup
```julia
using Pkg3
add TimesDates
```

## Some Examples
```julia
using Dates, TimesDates

str1 = "2011-05-08T11:15:00"
str1 == string(TimeDate(str1))

str2 = "2018-03-09T18:29:00.04296875"
tmdt = TimeDate(str2)
str2 == string(tmdt)

Month(tmdt) == Month(3)
Microsecond(tmdt) == Microsecond(968)
Nanosecond(tmdt) == Nanosecond(750)

tmdt + Minute(60*9+22)

show(td)
# or
using Dates, TimeZones, TimesDates



