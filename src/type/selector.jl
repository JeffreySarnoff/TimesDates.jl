Year(td::TimeDate)   = Year(td.on_date)
Month(td::TimeDate)  = Month(td.on_date)
Day(td::TimeDate)    = Day(td.on_date)
Hour(td::TimeDate)   = Hour(td.at_time)
Minute(td::TimeDate) = Minute(td.at_time)
Second(td::TimeDate) = Second(td.at_time)
Millisecond(td::TimeDate) = Millisecond(td.at_time)
Microsecond(td::TimeDate) = Microsecond(td.at_time)
Nanosecond(td::TimeDate)  = Nanosecond(td.at_time)

Year(tdz::TimeDateZone)   = Year(tdz.on_date)
Month(tdz::TimeDateZone)  = Month(tdz.on_date)
Day(tdz::TimeDateZone)    = Day(tdz.on_date)
Hour(tdz::TimeDateZone)   = Hour(tdz.at_time)
Minute(tdz::TimeDateZone) = Minute(tdz.at_time)
Second(tdz::TimeDateZone) = Second(tdz.at_time)
Millisecond(tdz::TimeDateZone) = Millisecond(tdz.at_time)
Microsecond(tdz::TimeDateZone) = Microsecond(tdz.at_time)
Nanosecond(tdz::TimeDateZone)  = Nanosecond(tdz.at_time)

year(td::TimeDate)   = year(td.on_date)
month(td::TimeDate)  = month(td.on_date)
day(td::TimeDate)    = day(td.on_date)
hour(td::TimeDate)   = hour(td.at_time)
minute(td::TimeDate) = minute(td.at_time)
second(td::TimeDate) = second(td.at_time)
millisecond(td::TimeDate) = millisecond(td.at_time)
microsecond(td::TimeDate) = microsecond(td.at_time)
nanosecond(td::TimeDate)  = nanosecond(td.at_time)

year(tdz::TimeDateZone)   = year(tdz.on_date)
month(tdz::TimeDateZone)  = month(tdz.on_date)
day(tdz::TimeDateZone)    = day(tdz.on_date)
hour(tdz::TimeDateZone)   = hour(tdz.at_time)
minute(tdz::TimeDateZone) = minute(tdz.at_time)
second(tdz::TimeDateZone) = second(tdz.at_time)
millisecond(tdz::TimeDateZone) = millisecond(tdz.at_time)
microsecond(tdz::TimeDateZone) = microsecond(tdz.at_time)
nanosecond(tdz::TimeDateZone)  = nanosecond(tdz.at_time)

# ======================================= #

#=
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
=#
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

#=
function Dates.Day(cp::CompoundPeriod)
    periods = cp.periods
    isempty(periods) && return Dates.Day(0)
    firstperiod = periods[1]
    !isa(firstperiod, Day) && return Dates.Day(0)
    return firstperiod
end
=#

function Dates.Time(cp::CompoundPeriod)
    cperiods = canonical(cp)
    days, cperiods = isolate_days(cperiods)
    return isempty(cperiods) ? Time(0) : Time(0) + cperiods
end


function isolate_days(cp::CompoundPeriod)
    days = Day(cp)
    cp = cp - days
    return days, cp
end
