module TimesDates

export TimeDate, TimeDateZone,
    timeofday, date, zone, tzdefault!

import Base:  (==), (!=), (<=), (<), isless, isequal
import Dates: Year, Month, Day, Hour, Minute, Second,
              Millisecond, Microsecond, Nanosecond,
              year, month, day, hour, minute, second,
              millisecond, microsecond, nanosecond

using Dates: CompoundPeriod
using Dates

using TimeZones

const tzUTC = timezones_from_abbr("UTC")[1]
const tzLOCAL = localzone()

TZ_DEFAULT = [tzLOCAL]
tzdefault() = TZ_DEFAULT[1]

function tzdefault!(x::TimeZone)
    TZ_DEFAULT[1] = x
end

mutable struct TimeDate
    attime::Time
    ondate::Date
end

@inline timeofday(x::TimeDate) = x.attime
@inline time(x::TimeDate) = x.attime
@inline date(x::TimeDate) = x.ondate

mutable struct TimeDateZone
    attime::Time
    ondate::Date
    inzone::TimeZone
end

@inline timeofday(x::TimeDateZone) = x.attime
@inline time(x::TimeDateZone) = x.attime
@inline date(x::TimeDateZone) = x.ondate
@inline zone(x::TimeDateZone) = x.inzone

timeofday(x::DateTime) = Time(x)
timeofday(x::ZonedDateTime) = Time(DateTime(x))

TimeDate(x::TimeDate) = x
TimeDateZone(x::TimeDateZone) = x

TimeDate(x::TimeDateZone) = TimeDate(time(x), date(x))
TimeDateZone(x::TimeDate) = TimeDateZone(time(x), date(x), tzdefault())
TimeDateZone(x::TimeDate, z::TimeZone) = TimeDateZone(time(x), date(x), z)

TimeDate(z::Date) =
    TimeDate(Time(0), Date(z))
TimeDateZone(z::Date) =
    TimeDateZone(Time(0), Date(z), tzdefault())
TimeDateZone(z::Date, tz::TimeZone) =
    TimeDateZone(Time(0), Date(z), tz)

TimeDate(z::Time) =
    TimeDate(z, Date(now()))
TimeDateZone(z::Time) =
    TimeDateZone(Time(z), Date(now()), tzdefault())
TimeDateZone(z::Time, tz::TimeZone) =
    TimeDateZone(Time(z), Date(now()), tz)

TimeDate(z::DateTime) =
    TimeDate(Time(z), Date(z))
TimeDateZone(z::DateTime) =
    TimeDateZone(Time(z), Date(z), tzdefault())
TimeDateZone(z::DateTime, tz::TimeZone) =
    TimeDateZone(Time(z), Date(z), tz)

TimeDate(z::ZonedDateTime) =
    TimeDate(Time(z.utc_datetime), Date(z.utc_datetime))
TimeDateZone(z::ZonedDateTime) =
    TimeDateZone(Time(z.utc_datetime), Date(z.utc_datetime), z.timezone)

ZonedDateTime(tdz::TimeDateZone) =
    ZonedDateTime(date(tdz)+time(tdz), zone(tdz))
ZonedDateTime(td::TimeDate) =
    ZonedDateTime(date(td)+time(td), tzdefault())
ZonedDateTime(td::TimeDate, z::TimeZone) =
    ZonedDateTime(date(td)+time(td), z)

DateTime(tdz::TimeDateZone) = date(tdz)+time(tdz)
DateTime(td::TimeDate) = date(td)+time(td)

Date(tdz::TimeDateZone) = date(tdz)
Time(tdz::TimeDateZone) = time(tdz)
TimeZone(tdz::TimeDateZone) = zone(tdz)

Date(td::TimeDate) = date(td)
Time(td::TimeDate) = time(td)
    

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


Base.convert(::Type{CompoundPeriod},x::CompoundPeriod) = x

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
    hors, mins = fldmod(mins, 60)
    dys, hors = fldmod(hors, 24)
    result = CompoundPeriod(Day(dys), Hour(hors), Minute(mins),
                            Second(secs))
    return result
end
function canonical(x::Millisecond)
    secs, millis = fldmod(x.value, 1_000)
    mins, secs = fldmod(secs, 60)
    hors, mins = fldmod(mins, 60)
    dys, hors = fldmod(hors, 24)

    result = CompoundPeriod(Day(dys), Hour(hors), Minute(mins),
                            Second(secs), Millisecond(millis))
    return result
end
function canonical(x::Microsecond)
    millis, micros = fldmod(x.value, 1_000)
    secs, millis = fldmod(millis, 1_000)
    mins, secs = fldmod(secs, 60)
    hors, mins = fldmod(mins, 60)
    dys, hors = fldmod(hors, 24)
    result = CompoundPeriod(Day(dys), Hour(hors), Minute(mins),
                            Second(secs), Millisecond(millis),
                            Microsecond(micros))
    return result
end
function canonical(x::Nanosecond)
    micros, nanos = fldmod(x.value, 1_000)
    millis, micros = fldmod(micros, 1_000)
    secs, millis = fldmod(millis, 1_000)
    mins, secs = fldmod(secs, 60)
    hors, mins = fldmod(mins, 60)
    dys, hors = fldmod(hors, 24)
    result = CompoundPeriod(Day(dys), Hour(hors), Minute(mins),
                            Second(secs), Millisecond(millis),
                            Microsecond(micros), Nanosecond(nanos))
    return result
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


function Base.convert(::Type{Time}, cp::CompoundPeriod)
    cperiods = canonical(cp)
    days, cperiods = isolate_days(cperiods)
    return isempty(cperiods) ? Time(0) : Time(0) + cperiods
end

function Dates.Time(cp::CompoundPeriod)
    cperiods = canonical(cp)
    days, cperiods = isolate_days(cperiods)
    return isempty(cperiods) ? Time(0) : Time(0) + cperiods
end


for P in (:Nanosecond, :Microsecond, :Millisecond, :Second, :Minute, :Hour)
  @eval begin
        
    function Base.:(+)(td::TimeDate, tp::$P)
        dateof = date(td)
        timeof = time(td)
        compoundtime = CompoundPeriod(timeof)
        compoundtime += tp
        compoundtime = canonical(compoundtime)
        deltadays, compoundtime = isolate_days(compoundtime)    

        timeof = Time(0) + compoundtime
        dateof += deltadays

        return TimeDate(timeof, dateof)
     end

     function Base.:(-)(td::TimeDate, tp::$P)
        dateof = date(td)
        timeof = time(td)
        compoundtime = CompoundPeriod(timeof)
        compoundtime -= tp
        compoundtime = canonical(compoundtime)
        deltadays, compoundtime = isolate_days(compoundtime)    

        timeof = Time(0) + compoundtime
        dateof += deltadays

        return TimeDate(timeof, dateof)
     end

     function Base.:(+)(tdz::TimeDateZone, tp::$P)
        td = TimeDate(tdz)
        td = td + tp

        return TimeDateZone(time(td), date(td), zone(tdz))
     end
        
     function Base.:(-)(tdz::TimeDateZone, tp::$P)
        td = TimeDate(tdz)
        td = td - tp

        return TimeDateZone(time(td), date(td), zone(tdz))
     end

  end
end

Base.:(+)(td::TimeDate, dy::Day) = TimeDate(time(td), date(td)+dy)
Base.:(-)(td::TimeDate, dy::Day) = TimeDate(time(td), date(td)-dy)
Base.:(+)(tdz::TimeDateZone, dy::Day) = TimeDate(time(tdz), date(tdz)+dy, zone(tdz))
Base.:(-)(tdz::TimeDateZone, dy::Day) = TimeDate(time(tdz), date(tdz)-dy, zone(tdz))

function Base.:(+)(td::TimeDate, cperiod::CompoundPeriod)
    dateof = date(td)
    tdperiod = CompoundPeriod(time(td))
    tdperiod = tdperiod + cperiod
    tdperiod = canonical(tdperiod)
    days, cperiod = isolate_days(tdperiod)
    timeof = Time(0) + cperiod
    dateof += days
    return TimeDate(timeof, dateof)
end

function Base.:(-)(td::TimeDate, cperiod::CompoundPeriod)
    dateof = date(td)
    tdperiod = CompoundPeriod(time(td))
    tdperiod = tdperiod - cperiod
    tdperiod = canonical(tdperiod)
    days, cperiod = isolate_days(tdperiod)
    timeof = Time(0) + cperiod
    dateof += days
    return TimeDate(timeof, dateof)
end

function Base.:(+)(tdz::TimeDateZone, cperiod::CompoundPeriod)
    td = TimeDate(tdz)
    td = td + cperiod
    return TimeDateZone(time(td), date(td), zone(tdz))
end

function Base.:(-)(tdz::TimeDateZone, cperiod::CompoundPeriod)
    td = TimeDate(tdz)
    td = td - cperiod
    return TimeDateZone(time(td), date(td), zone(tdz))
end

Base.:(+)(period::Period, td::TimeDate) = td + period
Base.:(+)(period::Period, tdz::TimeDateZone) = tdz + period
Base.:(+)(cperiod::CompoundPeriod, td::TimeDate) = td + cperiod
Base.:(+)(cperiod::CompoundPeriod, tdz::TimeDateZone) = tdz + cperiod

function Base.:(-)(atd::TimeDate, btd::TimeDate)
    atime, adate = time(atd), date(atd)
    btime, bdate = time(btd), date(btd)
    dtime = atime - btime
    ddate = adate - bdate
    delta = canonical(CompoundPeriod(ddate, dtime))
    return delta
end


function Base.:(==)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    isempty(delta)
end
function Base.:(!=)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    !isempty(delta)
end
function Base.:(<)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    return !isempty(delta) && signbit(delta.periods[1])
end    
function Base.:(<=)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    return isempty(delta) || signbit(delta.periods[1])
end    
(isequal)(atd::TimeDate, btd::TimeDate) = atd == btd
(isless)(atd::TimeDate, btd::TimeDate) = atd < btd


function Base.string(td::TimeDate)
    return string(date(td),"T",time(td))
end

function Base.string(tdz::TimeDateZone)
    return string(date(tdz),"T",time(tdz)," ",zone(tdz))
end

Base.show(io::IO, td::TimeDate) = print(io, string(td))
Base.show(io::IO, tdz::TimeDateZone) = print(io, string(tdz))
Base.show(td::TimeDate) = print(Base.STDOUT, string(td))
Base.show(tdz::TimeDateZone) = print(Base.STDOUT, string(tdz))

splitstring(str::String, splitat::String) = map(String, split(str, splitat))

function TimeDate(str::String)
    !contains(str, "T") && throw(ErrorException("\"$str\" is not recognized as a TimeDate"))
    
    datepart, inttimepart, fractimepart = datetimeparts(str)
    
    dateof = parse(Date, datepart)
    timeof = parse(Time, inttimepart)
    timeof = fractionaltime(timeof, fractimepart)

    return TimeDate(timeof, dateof)
end

function TimeDateZone(str::String)
    !contains(str, "T") && throw(ErrorException("\"$str\" is not recognized as a TimeDateZone"))
    
    datepart, inttimepart, fractimepart, zonepart = datetimezoneparts(str) 

    dateof = parse(Date, datepart)
    timeof = parse(Time, inttimepart)
    timeof = fractionaltime(timeof, fractimepart)
    
    zoneof = (all_timezones()[timezone_names() .== zonepart])[1]

    return TimeDateZone(timeof, dateof, zoneof)
end


function fractionaltime(timeof::Time, fractimepart::String)
    n = length(fractimepart)
    if n > 0
        fractime = parse(Int, fractimepart)
        if n <= 3
            delta = fld(1000,10^n)
            fractime *= delta
            timeof += Millisecond(fractime)
        elseif n <= 6
            delta = fld(1000,10^(n-3))
            fractime *= delta
            timeof += Microsecond(fractime)
        else
            delta = fld(1000,10^(n-6))
            fractime *= delta
            timeof += Nanosecond(fractime)
        end
    end
    return timeof
end

function datetimeparts(str::String)
    datepart, timepart = splitstring(str, "T")
    if contains(timepart, ".")
        inttimepart, fractimepart = splitstring(timepart, ".")
    else
        inttimepart = timepart
        fractimepart = ""
    end

    return datepart, inttimepart, fractimepart
end

function datetimezoneparts(str::String)
    datepart, inttimepart, parts = datetimeparts(str)
    
    if contains(parts, " ")
        fractimepart, zonepart = splitstring(parts, " ")
    else
        fractimepart = parts
        zonepart = string(tzdefault())
    end

    return datepart, inttimepart, fractimepart, zonepart
end

end # TimesDates

