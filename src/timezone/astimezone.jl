TimeZone(x::ZonedDateTime) = x.timezone

function astimezone(x::TimeDateZone, tz::FixedTimeZone)
    on_date = x.on_date
    at_time = x.at_time
    fast_time = fasttime(at_time)
    
    zdt = ZonedDateTime(x)
    zdt = astimezone(zdt, tz)
    tdz = TimeDateZone(zdt)
    tdz = tdz + fast_time
    return tdz
end

function astimezone(x::TimeDateZone, tz::VariableTimeZone)
    on_date = x.on_date
    at_time = x.at_time
    fast_time = fasttime(at_time)
    
    zdt = ZonedDateTime(x)
    zdt = astimezone(zdt, tz)
    tdz = TimeDateZone(zdt)
    tdz = tdz + fast_time
    return tdz
end

