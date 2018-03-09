module TimesDates

export TimeDate, TimeDateZone,
       timeofday, date, zone, tzdefault!
       
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

function canonical(x::Millisecond)
    secs, millis = fldmod(x.value, 1_000)
    mins, secs = fldmod(secs, 60)
    hors, mins = fldmod(mins, 60)
    dys, hors = fldmod(hors, 24)
  
    result = CompoundPeriod(Day(dys), Hour(hors), Minute(mins),
                            Second(secs), Millisecond(millis))
    return result
end  

function canonical(x::Second)
    mins, secs = fldmod(x.value, 60)
    hors, mins = fldmod(mins, 60)
    dys, hors = fldmod(hors, 24)
    result = CompoundPeriod(Day(dys), Hour(hors), Minute(mins),
                            Second(secs))
    return result
end  



function canonical(x::Second)
    mins, secs = fldmod(x.value, 60)
    hors, mins = fldmod(mins, 60)
    dys, hors = fldmod(hors, 24)
    result = CompoundPeriod(Day(dys), Hour(hors), Minute(mins),
                            Second(secs))
    return result
end  

function canonical(x::Minute)
    hors, mins = fldmod(x.value, 60)
    dys, hors = fldmod(hors, 24)
    result = CompoundPeriod(Day(dys), Hour(hors), Minute(mins))
    return result
end  

function canonical(x::Hour)
    dys, hors = fldmod(x.value, 24)
    result = CompoundPeriod(Day(dys), Hour(hors))
    return result
end  

function canonical(x::Day)  
    result = CompoundPeriod(x)
    return result
end  

# separate a CompoundPeriod into periods >= Millisecond, and periods < Millisecond
function twocompoundperiods(cp::CompoundPeriod)
    periods = cp.periods
    n = length(periods)
    ptypes = map(typeof, periods)
    if ptypes[end] === Nanosecond
      if n>1 && ptypes[end-1] == Microsecond
         largecp = CompoundPeriod(periods[1:end-2])
         smallcp = CompoundPeriod(periods[end-1:end])
      else
         largecp = CompoundPeriod(periods[1:end-1])
         smallcp = CompoundPeriod(periods[end])
      end
    elseif ptypes[end] == Microsecond
         largecp = CompoundPeriod(periods[1:end-1])
         smallcp = CompoundPeriod(periods[end])
    else
         largecp = cp
         smallcp = CompoundPeriod()
    end
    return largecp, smallcp
end

      
      

for P in (:Nanosecond, :Microsecond, :Millisecond,
          :Second, :Minute, :Hour, :Day)
  @eval begin
    function Base.:(+)(td::TimeDate, tp::$P)
        cperiods = canonical(tp)
        largep, smallp = twocompoundperiods(cperiods)
        datetime = (time(td)+date(td)) + largep
        timeof = Time(datetime) + smallp
        dateof = Date(datetime)
        if timeof+date(td) < datetime
           dateof += Day(1)
        end
        return TimeDate(timeof, dateof)
    end
    function Base.:(-)(td::TimeDate, tp::$P)
        cperiods = canonical(tp)
        largep, smallp = twocompoundperiods(cperiods)
        datetime = (time(td)+date(td)) - largep
        timeof = Time(datetime) - smallp
        dateof = Date(datetime)
        if timeof+date(td) < datetime
           dateof += Day(1)
        end
        return TimeDate(timeof, dateof)
    end
    function Base.:(+)(tdz::TimeDateZone, tp::$P)
        cperiods = canonical(tp)
        largep, smallp = twocompoundperiods(cperiods)
        datetime = (time(tdz)+date(tdz)) + largep
        timeof = Time(datetime) + smallp
        dateof = Date(datetime)
        if timeof+date(tdz) < datetime
           dateof += Day(1)
        end
        return TimeDateZone(timeof, dateof, zone(tdz))
    end
    function Base.:(-)(tdz::TimeDateZone, tp::$P)
        cperiods = canonical(tp)
        largep, smallp = twocompoundperiods(cperiods)
        datetime = (time(tdz)+date(tdz)) - largep
        timeof = Time(datetime) - smallp
        dateof = Date(datetime)
        if timeof+date(tdz) < datetime
           dateof += Day(1)
        end
        return TimeDateZone(timeof, dateof, zone(tdz))
    end
  end
end

end  # TimesDates
