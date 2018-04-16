TimeDate(zdt::ZonedDateTime) = TimeDate(DateTime(zdt))
TimeDate(dtm::DateTime) = TimeDate(Time(dtm), Date(dtm))
TimeDate(dt::Date) = TimeDate(Time(0), dt)
TimeDate(tm::Time) = throw(ErrorException("TimeDate(::Time) is not used"))

function TimeDate(dtm::DateTime, period::P) where {P<:Period}
    timedate = TimeDate(dtm)
    timedate += period
    return timedate
end

function TimeDate(dtm::DateTime, cperiod::CompoundPeriod)
    timedate = TimeDate(dtm)
    timedate = timedate + cperiod
    return timedate
end

@inline function TimeDate(td::TimeDate, period::P) where {P<:Period}
    td += period
    return td
end

@inline function TimeDate(td::TimeDate, cperiod::CompoundPeriod)
    td += cperiod
    return td
end


function TimeDate(tdz::TimeDateZone)
    slow_time = slowtime(at_time(tdz))
    fast_time = fasttime(at_time(tdz))
    zdt = ZonedDateTime(on_date(tdz)+slow_time, tdz.in_zone)
    dttm = DateTime(zdt)
    tmdt = TimeDate(Time(dttm), Date(dttm)) + fast_time
    return tmdt
end

function TimeDateZone(dtm::DateTime, tz::Z) where {Z<:TimeZone}
    zdt = ZonedDateTime(dtm, tz)
    return TimeDateZone(zdt)
end

function TimeDateZone(td::TimeDate, tz::Z) where {Z<:TimeZone}
    dt = on_date(td)
    tm = at_time(td)
    tzd = TimeDateZone(tm, dt, tz)
    return tdz
end


function TimeDateZone(zdt::ZonedDateTime)
    dttm = DateTime(zdt)
    dt = Date(dttm)
    tm = Time(dttm)
    #utcoffset = offset_Seconds_from_ut(zdt.zone.offset)
    tdz = TimeDateZone(tm, dt, zdt.timezone, zdt.zone)
    return tdz
end



TimeDateZone(dt::Date, tm::Time, tz::Z) where {Z<:TimeZone} =
    TimeDateZone(ZonedDateTime(dt+slowtime(tm), tz))
TimeDateZone(tm::Time, dt::Date, tz::Z) where {Z<:TimeZone} =
    TimeDateZone(dt+slowtime(tm), tz)
TimeDateZone(dt::Date, tz::Z) where {Z<:TimeZone} =
    TimeDateZone(ZonedDateTime(dt+Time(0), tz))

TimeDateZone(tm::Time) = throw(ErrorException("TimeDateZone(::Time) is not used"))


DateTime(td::TimeDate) = DateTime(td.on_date + slowtime(td.at_time))
Date(td::TimeDate) = td.on_date
Time(td::TimeDate) = td.at_time
DateTime(tdz::TimeDateZone) = DateTime(TimeDate(tdz))

function ZonedDateTime(td::TimeDate, tz::TimeZone)
    datetime = on_date(td) + slowtime(at_time(td))
    zdt = ZonedDateTime(datetime, tz)
    return zdt
end
ZonedDateTime(tm::Time, dt::Date, tz::TimeZone) =
    ZonedDateTime(TimeDate(tm,dt), tz)

ZonedDateTime(tdz::TimeDateZone) = ZonedDateTime(TimeDate(tdz), tdz.in_zone)
