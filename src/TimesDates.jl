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

end
