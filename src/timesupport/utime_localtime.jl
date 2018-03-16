
localtime(::Type{TimeDate}) = TimeDate(Dates.now())
localtime(::Type{TimeDateZone}) = TimeDateZone(Dates.now(), TZ_LOCAL)

utime(::Type{TimeDate}) = TimeDate(Dates.now(Dates.UTC))
utime(::Type{TimeDateZone}) = TimeDateZone(Dates.now(UTC), TZ_UT)

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
