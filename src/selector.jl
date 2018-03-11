

Year(td::TimeDate)   = Year(date(td))
Month(td::TimeDate)  = Month(date(td))
Day(td::TimeDate)    = Day(date(td))
Hour(td::TimeDate)   = Hour(time(td))
Minute(td::TimeDate) = Minute(time(td))
Second(td::TimeDate) = Second(time(td))
Millisecond(td::TimeDate) = Millisecond(time(td))
Microsecond(td::TimeDate) = Microsecond(time(td))
Nanosecond(td::TimeDate)  = Nanosecond(time(td))

Year(tdz::TimeDateZone)   = Year(date(tdz))
Month(tdz::TimeDateZone)  = Month(date(tdz))
Day(tdz::TimeDateZone)    = Day(date(tdz))
Hour(tdz::TimeDateZone)   = Hour(time(tdz))
Minute(tdz::TimeDateZone) = Minute(time(tdz))
Second(tdz::TimeDateZone) = Second(time(tdz))
Millisecond(tdz::TimeDateZone) = Millisecond(time(tdz))
Microsecond(tdz::TimeDateZone) = Microsecond(time(tdz))
Nanosecond(tdz::TimeDateZone)  = Nanosecond(time(tdz))

year(td::TimeDate)   = year(date(td))
month(td::TimeDate)  = month(date(td))
day(td::TimeDate)    = day(date(td))
hour(td::TimeDate)   = hour(time(td))
minute(td::TimeDate) = minute(time(td))
second(td::TimeDate) = second(time(td))
millisecond(td::TimeDate) = millisecond(time(td))
microsecond(td::TimeDate) = microsecond(time(td))
nanosecond(td::TimeDate)  = nanosecond(time(td))

year(tdz::TimeDateZone)   = year(date(tdz))
month(tdz::TimeDateZone)  = month(date(tdz))
day(tdz::TimeDateZone)    = day(date(tdz))
hour(tdz::TimeDateZone)   = hour(time(tdz))
minute(tdz::TimeDateZone) = minute(time(tdz))
second(tdz::TimeDateZone) = second(time(tdz))
millisecond(tdz::TimeDateZone) = millisecond(time(tdz))
microsecond(tdz::TimeDateZone) = microsecond(time(tdz))
nanosecond(tdz::TimeDateZone)  = nanosecond(time(tdz))

# ======================================= #

function canonical(x::Day)
     CompoundPeriod(x, Hour(0), Minute(0), Second(0),
        Millisecond(0), Microsecond(0), Nanosecond(0))
end
function canonical(x::Hour)
    days, hours = fldmod(x.value, 24)
    CompoundPeriod(Day(days), Hour(hours), Minute(0), Second(0),
        Millisecond(0), Microsecond(0), Nanosecond(0))
end
function canonical(x::Minute)
    hours, mins = fldmod(x.value, 60)
    days, hours = fldmod(hours, 24)
    CompoundPeriod(Day(days), Hour(hours), Minute(mins), Second(0),
        Millisecond(0), Microsecond(0), Nanosecond(0))
end
function canonical(x::Second)
    mins, secs = fldmod(x.value, 60)
    hours, mins = fldmod(mins, 60)
    days, hours = fldmod(hours, 24)
    CompoundPeriod(Day(days), Hour(hours), Minute(mins), Second(secs),
        Millisecond(0), Microsecond(0), Nanosecond(0))
end
function canonical(x::Millisecond)
    secs, millis = fldmod(x.value, 1_000)
    mins, secs = fldmod(secs, 60)
    hours, mins = fldmod(mins, 60)
    days, hours = fldmod(hours, 24)
    CompoundPeriod(Day(days), Hour(hours), Minute(mins), Second(secs),
        Millisecond(millis), Microsecond(0), Nanosecond(0))
end
function canonical(x::Microsecond)
    millis, micros = fldmod(x.value, 1_000)
    secs, millis = fldmod(millis, 1_000)
    mins, secs = fldmod(secs, 60)
    hours, mins = fldmod(mins, 60)
    days, hours = fldmod(hours, 24)
    CompoundPeriod(Day(days), Hour(hours), Minute(mins), Second(secs),
        Millisecond(millis), Microsecond(micros), Nanosecond(0))
end
function canonical(x::Nanosecond)
    micros, nanos = fldmod(x.value, 1_000)
    millis, micros = fldmod(micros, 1_000)
    secs, millis = fldmod(millis, 1_000)
    mins, secs = fldmod(secs, 60)
    hours, mins = fldmod(mins, 60)
    days, hours = fldmod(hours, 24)
    CompoundPeriod(Day(days), Hour(hours), Minute(mins), Second(secs),
        Millisecond(millis), Microsecond(micros), Nanosecond(nanos))
end

function canonical(days::Day, hours::Hour=Hour(0), minutes::Minute=Minute(0), seconds::Second=Second(0), millisecs::Millisecond=Millisecond(0), microsecs::Microsecond=Microsecond(0), nanosecs::Nanosecond=Nanosecond(0))
    CompoundPeriod(Day(days), Hour(hours), minutes, seconds, millisecs, microsecs, nanosecs)
end
function canonical(hours::Hour, minutes::Minute=Minute(0), seconds::Second=Second(0), millisecs::Millisecond=Millisecond(0), microsecs::Microsecond=Microsecond(0), nanosecs::Nanosecond=Nanosecond(0))
    days, hours = fldmod(hours.value, 24)
    CompoundPeriod(Day(days), Hour(hours), minutes, seconds, millisecs, microsecs, nanosecs)
end
function canonical(minutes::Minute, seconds::Second=Second(0), millisecs::Millisecond=Millisecond(0), microsecs::Microsecond=Microsecond(0), nanosecs::Nanosecond=Nanosecond(0))
    hours, mins = fldmod(minutes.value, 60)
    canonical(Hour(hours), Minute(mins), seconds, millisecs, microsecs, nanosecs)
end
function canonical(seconds::Second, millisecs::Millisecond=Millisecond(0), microsecs::Microsecond=Microsecond(0), nanosecs::Nanosecond=Nanosecond(0))
    mins, secs = fldmod(seconds.value, 60)
    canonical(Minute(mins), Second(secs), millisecs, microsecs, nanosecs)
end
function canonical(millisecs::Millisecond, microsecs::Microsecond=Microsecond(0), nanosecs::Nanosecond=Nanosecond(0))
    secs, millis = fldmod(millisecs.value, 1_000)
    canonical(Second(secs), Millisecond(millis), microsecs, nanosecs)
end
function canonical(microsecs::Microsecond, nanosecs::Nanosecond=Nanosecond(0))
    millis, micros = fldmod(microsecs.value, 1_000)
    canonical(Millisecond(millis), Microsecond(micros), nanosecs)
end
function canonical(x::Nanosecond)
    micros, nanos = fldmod(x.value, 1_000)
    canonical(Microsecond(micros), Nanosecond(nanos))
end

function canonical(x::CompoundPeriod)
    periods = x.periods
    periods = map(canonical, periods)
    compound = isempty(periods) ? CompoundPeriod() : reduce(+, periods)
    # repeat to roll up any period multiplicties
    periods = compound.periods
    periods = map(canonical, periods)
    compound = isempty(periods) ? CompoundPeriod() : reduce(+, periods)
    return compound
end

function Dates.Day(cp::CompoundPeriod)
    periods = cp.periods
    isempty(periods) && return Dates.Day(0)
    firstperiod = periods[1]
    !isa(firstperiod, Day) && return Dates.Day(0)
    return firstperiod
end

function isolate_days(cp::CompoundPeriod)
    days = Day(cp)
    cp = cp - days
    return days, cp
end
