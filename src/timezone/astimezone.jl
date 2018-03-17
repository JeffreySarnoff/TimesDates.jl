timezone(x::ZonedDateTime) = x.timezone

function astimezone(x::TimeDateZone, tz::TimeZone)
    on_date = x.on_date
    at_time = x.at_time
    fast_time = fasttime(at_time)
    slow_time = at_time - fast_time
    in_zone = x.in_zone
    zdt = ZonedDateTime(on_date+slow_time, in_zone)
    zdt = astimezone(zdt, tz)
    tdz = TimeDateZone(zdt)
    tdz = tdz + fast_time
    return tdz
end

function astimezone(x::TimeDate, tz::TimeZone)
    tdz = TimeDateZone(x)
    return astimezone(tdz, tz)
end
