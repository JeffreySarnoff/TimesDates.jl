__precompile__()

module TimesDates

export TimeDate, TimeDateZone,
    TimeZone,
    timezone, time, date, tzdefault, tzdefault!,
    localtime, utime, astimezone, TZ_LOCAL, TZ_UT,
    stringwithzoneff

import Base: promote_rule, convert, string, show, showcompact,
             (==), (!=), (<=), (<), (>), (>=), isless, isequal,
             isempty, time

import Base.Math: (+), (-), (*), (/),
                  fld, cld, div, rem, mod, round

import Dates: Time, Date, DateTime,
              Year, Month, Day, Hour, Minute, Second,
              Millisecond, Microsecond, Nanosecond,
              year, month, day, hour, minute, second,
              millisecond, microsecond, nanosecond

using Dates: AbstractTime, CompoundPeriod
using Dates

import TimeZones: @tz_str, ZonedDateTime, TimeZone,
    localzone, astimezone, FixedTimeZone, VariableTimeZone,
    all_timezones, timezone_names

# ======================================= #

include("timezone/timezones.jl")
include("timezone/tzdefault.jl")

# ======================================= #

include("type/nanotime.jl")
include("type/timeparts.jl")
include("type/constructor.jl")
include("type/selector.jl")
include("type/compare.jl")
include("type/addsub.jl")
include("type/string_show.jl")

# ======================================= #

include("justwork/slow_fast.jl")
include("justwork/with_zone.jl")
include("justwork/utime_localtime.jl")

end # TimesDates
