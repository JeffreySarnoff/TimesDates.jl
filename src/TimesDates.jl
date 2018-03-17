__precompile__()

module TimesDates

export TimeDate, TimeDateZone,
    TimeZone,
    timezone, time, date, tzdefault, tzdefault!,
    localtime, utime, astimezone, TZ_LOCAL, TZ_UT,
    stringwithzone, typesof

import Base: promote_rule, convert, string, show, showcompact,
             (==), (!=), (<=), (<), (>), (>=), isless, isequal,
             isempty, time, min, max, minmax

import Base: start, done, next, eltype, length, size

import Base.Math: (+), (-), (*), (/),
                  fld, cld, div, rem, mod, round

import Dates: Time, Date, DateTime,
              Year, Month, Day, Hour, Minute, Second,
              Millisecond, Microsecond, Nanosecond,
              year, month, day, hour, minute, second,
              millisecond, microsecond, nanosecond

using Dates: AbstractTime
using Dates
import Dates: CompoundPeriod

import TimeZones: @tz_str, ZonedDateTime, TimeZone,
    localzone, astimezone, FixedTimeZone, VariableTimeZone,
    all_timezones, timezone_names

const AkoTimeZone = Union{FixedTimeZone, VariableTimeZone}


# ======================================= #

include("support/typesof.jl")
include("support/ctime.jl")

include("type/nanotime.jl")

include("timesupport/zoneoffset.jl")
include("timesupport/utime_localtime.jl")
include("timesupport/slow_fast.jl")

include("timezone/timezones.jl")
include("timezone/tzdefault.jl")

include("timezone/astimezone.jl")

include("type/constructor.jl")
include("type/compound.jl")
include("type/convert_into_others.jl")

include("type/selector.jl")
include("type/compare.jl")
include("type/addsub.jl")
include("type/string_show.jl")

# ======================================= #


end # TimesDates

