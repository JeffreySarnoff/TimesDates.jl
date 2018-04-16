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
    timedate = TimeDate(tdz.at_time, tdz.on_date)
    offset = tdz.at_zone.offset.std + tdz.at_zone.offset.dst
    timedate += offset
    return timedate
end



function TimeDateZone(zdt::ZonedDateTime)
    dtm = zdt.utc_datetime
    tz  = zdt.timezone
    utcoffset = offset_Seconds_from_ut(zdt.zone.offset)
    tdz = TimeDateZone(dtm, tz) - uctoffset
    return tdz
end

function TimeDateZone(td::TimeDate, tz::Z) where {Z<:TimeZone}
    dtm = slowtime(td)
    zdt = ZonedDateTime(dtm, tz)
    return TimeDateZone(zdt)
end


TimeDateZone(dtm::DateTime, tz::Z) where {Z<:TimeZone} =
    TimeDateZone(ZonedDateTime(dtm, tz))
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
    datetime = td.on_date + slowtime(td.at_time)
    zdt = ZonedDateTime(datetime, tz)
    return zdt
end
ZonedDateTime(tm::Time, dt::Date, tz::TimeZone) =
    ZonedDateTime(TimeDate(tm,dt), tz)

ZonedDateTime(tdz::TimeDateZone) = ZonedDateTime(TimeDate(tdz), tdz.in_zone)
