tzdefault() = localzone()

TimeZone(tz::FixedTimeZone) = tz
TimeZone(tz::VariableTimeZone) = tz
TimeZone(zdt::ZonedDateTime) = zdt.timezone
TimeZone(tdz::TimeDateZone) = tdz.in_zone


function astimezone(x::TimeDateZone, tz::T) where
                    {T<:Union{FixedTimeZone,VariableTimeZone}}
    fast_time = fasttime(x)
    zdt = ZonedDateTime(x)
    zdt = astimezone(zdt, tz)
    tdz = TimeDateZone(zdt)
    tdz = tdz + fast_time
    return tdz
end


#const TZ_UT = tz"UTC"
#const TZ_LOCAL = localzone()

