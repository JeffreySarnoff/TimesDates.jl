module TimesDates

export TimeDate, TimeDateZone,
       time, date, timezone,  tzdefault!

import Base:  (==), (!=), (<=), (<), isless, isequal, isempty, time

import Dates: Year, Month, Day, Hour, Minute, Second,
              Millisecond, Microsecond, Nanosecond,
              year, month, day, hour, minute, second,
              millisecond, microsecond, nanosecond

using Dates: CompoundPeriod
using Dates

using TimeZones
include("tzdefault.jl")

# ======================================= #

mutable struct TimeDate
    attime::Time
    ondate::Date
end

@inline time(x::TimeDate) = x.attime
@inline date(x::TimeDate) = x.ondate

mutable struct TimeDateZone
    attime::Time
    ondate::Date
    inzone::TimeZone
end

@inline time(x::TimeDateZone) = x.attime
@inline date(x::TimeDateZone) = x.ondate
@inline zone(x::TimeDateZone) = x.inzone

# ======================================= #

include("constructor.jl")
include("selector.jl")
include("string_show.jl")



end # TimesDates

