struct TimeDateParts <: HighResParts
    date::Date
    slowtime::Time
    fasttime::Nanosecond
end

struct TimeDateZoneParts <: HighResParts
    date::Date
    slowtime::Time
    fasttime::Nanosecond
    timezone::TimeZone
    zone::FixedTimeZone
end

function TimeDateParts(td::TimeDate)
    calendar_date = Date(td)
    slow_time = slowtd.at_time
    nano_time = fastnanos(td)
    return TimeDateParts(calendar_date, slow_time, nano_time)
end

function TimeDateZoneParts(tdz::TimeDateZone)
    calendar_date = Date(tdz)
    slow_time = slowtdz.at_time
    nano_time = fastnanos(tdz)
    time_zone = tdz.in_zone
    zone_at_time = ZonedDateTime(calendar_date+slow_time,time_zone).zone

    return TimeDateZoneParts(calendar_date, slow_time, nano_time, time_zone, zone_at_time)
end
