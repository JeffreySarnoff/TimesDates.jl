module TimesDates

export TimeDate, TimeDateZone,
       TimeZone, timezonename, astimezone, @tz_str,
       at_time, on_date, in_zone, at_zone

import Base: promote_type, promote_rule, convert, string, show,
             (==), (!=), (<=), (<), (>), (>=), isless, isequal,
             isempty, time, min, max, minmax

import Base: iterate, eltype, length, size

import Base.Math: (+), (-), (*), (/),
                  fld, cld, div, rem, mod, round

using Dates

import Dates: Time, Date, DateTime,
              Year, Month, Day, Hour, Minute, Second,
              Millisecond, Microsecond, Nanosecond,
              year, month, day, hour, minute, second,
              millisecond, microsecond, nanosecond

import Dates: Period, CompoundPeriod, AbstractTime

import Dates: yearmonthday, yearmonth, monthday, dayofmonth,
              dayofweek, isleapyear, daysinmonth, daysinyear,
              dayofyear, dayname, dayabbr,
              dayofweekofmonth, daysofweekinmonth, monthname, monthabbr,
              quarterofyear, dayofquarter,
              firstdayofweek, lastdayofweek,
              firstdayofmonth, lastdayofmonth,
              firstdayofyear, lastdayofyear,
              firstdayofquarter, lastdayofquarter,
              tonext, toprev


using CompoundPeriods
import CompoundPeriods: canonical

import TimeZones: @tz_str, ZonedDateTime, TimeZone,
    localzone, astimezone, UTCOffset, FixedTimeZone, VariableTimeZone,
    all_timezones, timezone_names

import TimeZones.value # value(offset::UTCOffset) = value(offset.std + offset.dst)


const AkoTimeZone = Union{FixedTimeZone, VariableTimeZone}

include("TimeDate.jl")
include("TimeDateZone.jl")
include("timeconsts.jl")


Date(x::Date) = x
Time(x::Time) = x
DateTime(x::DateTime) = x
ZonedDateTime(x::ZonedDateTime) = x

include("periods.jl")
include("select.jl")
include("arith.jl")
include("compare.jl")
include("showstring.jl")
include("passthru.jl")

"""
    TimeDate(::TimeDateZone)

conversion adds back timezone offset
- provides local wallclock time
"""
function TimeDate(tdz::TimeDateZone)
    TimeDate(tdz) + utcoffset(tdz)
end

"""
Same as `Dates.datetime2unix`, only with nanosecond granularity. Returns an Int instead of Float.
"""
function timedate2unix(x::TimeDate)
    millis = round(Int64, Dates.datetime2unix(DateTime(x)) * MILLISECONDS_PER_SECOND)
    millis * NANOSECONDS_PER_MILLISECOND +
        Dates.value(Microsecond(x)) * NANOSECONDS_PER_MICROSECOND +
        Dates.value(Nanosecond(x))
end

"""
Similar to `Dates.unix2datetime`. Works with the result of `timedate2unix`.
"""
function unix2timedate(v :: Int)
    nanos = v % NANOSECONDS_PER_MICROSECOND
    micros = div(v % NANOSECONDS_PER_MILLISECOND - nanos, MICROSECONDS_PER_MILLISECOND)
    epoch_millis = div(v, NANOSECONDS_PER_MILLISECOND)
    dt = Dates.unix2datetime(epoch_millis / 1000)
    TimeDate(dt) + Microsecond(micros) + Nanosecond(nanos)
end


end
