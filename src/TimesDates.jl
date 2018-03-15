__precompile__()

module TimesDates

export TimeDate, TimeDateZone,
    TimeZone,
    timezone, time, date, tzdefault, tzdefault!,
    localtime, uttime, astimezone, TZ_LOCAL, TZ_UT,
    stringcompact

import Base:  (==), (!=), (<=), (<), (>), (>=), isless, isequal,
              isempty, time, string, show, showcompact

import Base.Math: (+), (-), (*), (/),
                  fld, cld, div, rem, mod, round

import Dates: Time, Date, DateTime,
              Year, Month, Day, Hour, Minute, Second,
              Millisecond, Microsecond, Nanosecond,
              year, month, day, hour, minute, second,
              millisecond, microsecond, nanosecond

using Dates: CompoundPeriod
using Dates

import TimeZones: @tz_str, ZonedDateTime, TimeZone,
    localzone, astimezone, FixedTimeZone, VariableTimeZone

include("timezones.jl")
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
@inline timezone(x::TimeDateZone) = x.inzone

include("constructor.jl")
include("selector.jl")

include("interop.jl")

include("compare.jl")
include("addsub.jl")
include("string_show.jl")

end # TimesDates
