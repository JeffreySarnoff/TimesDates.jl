timezone(x::TimeDate) = tzdefault()
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

localtime(::Type{TimeDate}) = TimeDate(Dates.now())
localtime(::Type{TimeDateZone}) = TimeDateZone(Dates.now(), TZ_LOCAL)

uttime(::Type{TimeDate}) = TimeDate(Dates.now(Dates.UTC))
uttime(::Type{TimeDateZone}) = TimeDateZone(Dates.now(UTC), TZ_UT)

localtime(x::TimeDate) = astimezone(TimeDateZone(x), TZ_LOCAL)
uttime(x::TimeDate) = astimezone(TimeDateZone(x), TZ_UT)

localtime(x::TimeDateZone) = astimezone(x, TZ_LOCAL)
uttime(x::TimeDateZone) = astimezone(x, TZ_UT)

localtime() = localtime(TimeDateZone)
uttime() = uttime(TimeDateZone)

localtime(x::DateTime) = localtime(TimeDate(x))
uttime(x::DateTime) = uttime(TimeDate(x))
localtime(x::Date) = localtime(TimeDate(x))
uttime(x::Date) = uttime(TimeDate(x))
