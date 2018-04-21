
localtime(::Type{TimeDate}) = TimeDate(now())
localtime(::Type{TimeDateZone}) = TimeDateZone(TimeDate(now()), TZ_LOCAL)
localtime() = localtime(TimeDateZone)

univtime(::Type{TimeDate}) = TimeDate(now(Dates.UTC))
univtime(::Type{TimeDateZone}) = TimeDateZone(TimeDate(now(Dates.UTC)), TZ_UT)
univtime() = univtime(TimeDateZone)

function localtime(x::TimeDate)
    datetime = DateTime(x)
    fast_time = fasttime(x)
    return localtime(datetime) + fast_time
end

function univtime(x::TimeDate)
    datetime = DateTime(x)
    fast_time = fasttime(x)
    return univtime(datetime) + fast_time
end


function localtime(tdz::TimeDateZone)
    zdt = ZonedDateTime(tdz)
    datetime = DateTime(zdt)
    fast_time = fasttime(tdz)
    zdt = astimezone(zdt, localzone())
    tdz = TimeDateZone(zdt)
    tdz += fast_time
    return tdz
end

function univtime(tdz::TimeDateZone)
    zdt = ZonedDateTime(tdz)
    datetime = DateTime(zdt)
    fast_time = fasttime(tdz)
    zdt = astimezone(zdt, tz"UTC")
    tdz = TimeDateZone(zdt)
    tdz += fast_time
    return tdz
end


localtime(x::DateTime) = TimeDateZone(ZonedDateTime(x, localzone()))
univtime(x::DateTime) = TimeDateZone(ZonedDateTime(x, tz"UTC"))
localtime(x::Date) = localtime(DateTime(x))
univtime(x::Date) = univtime(DateTime(x))
