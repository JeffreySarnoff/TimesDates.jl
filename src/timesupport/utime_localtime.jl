
localtime(::Type{TimeDate}) = TimeDate(now())
localtime(::Type{TimeDateZone}) = TimeDateZone(now(), TZ_LOCAL)
localtime() = localtime(TimeDateZone)

utime(::Type{TimeDate}) = TimeDate(now(Dates.UTC))
utime(::Type{TimeDateZone}) = TimeDateZone(now(Dates.UTC), TZ_UT)
utime() = utime(TimeDateZone)

localtime(x::TimeDate) = astimezone(TimeDateZone(x), TZ_LOCAL)
utime(x::TimeDate) = astimezone(TimeDateZone(x), TZ_UT)

localtime(x::TimeDateZone) = astimezone(x, TZ_LOCAL)
utime(x::TimeDateZone) = astimezone(x, TZ_UT)

localtime() = localtime(TimeDateZone)
utime() = utime(TimeDateZone)

localtime(x::DateTime) = localtime(TimeDate(x))
utime(x::DateTime) = utime(TimeDate(x))
localtime(x::Date) = localtime(TimeDate(x))
utime(x::Date) = utime(TimeDate(x))
