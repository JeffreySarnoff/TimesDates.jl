timezone(x::ZonedDateTime) = x.timezone

function astimezone(x::TimeDateZone, tz::FixedTimeZone)
    on_date = x.on_date
    at_time = x.at_time
    fast_time = fasttime(at_time)
   
    zdt = ZonedDateTime(x)
    zdt_offset = value(zdt.zone.offset)
    tz_offset = value(tz.offset)
    
    zdt = astimezone(zdt, tz)
    tdz = TimeDateZone(zdt)
    
    if zdt_offset <= tz_offset
        tdz = tdz + fast_time
    else
        tdz = tdz - fast_time
    end
    
    return tdz
end

function astimezone(x::TimeDate, tz::TimeZone)
    tdz = TimeDateZone(x)
    return astimezone(tdz, tz)
end
