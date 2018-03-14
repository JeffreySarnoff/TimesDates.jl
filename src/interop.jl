timezone(x::TimeDate) = tzdefault()
timezone(x::ZonedDateTime) = x.timezone

function astimezone(x::TimeDateZone, tz::TimeZone)
    dt = date(x)
    tm = time(x)
    fasttm = Microsecond(tm) + Nanosecond(tm)
    tm = tm - fasttm
    zn = zone(x)
    zdt = ZonedDateTime(dt+tm, zn)
    zdt = astimezone(zdt, tz)
    tdz = TimeDateZone(zdt)
    tdz = tdz + fasttm
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
