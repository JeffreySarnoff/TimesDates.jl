TimeDate(x::TimeDate) = x
TimeDateZone(x::TimeDateZone) = x

TimeDate(x::TimeDateZone) = TimeDate(time(x), date(x))
TimeDateZone(x::TimeDate) = TimeDateZone(time(x), date(x), tzdefault())
TimeDateZone(x::TimeDate, z::TimeZone) = TimeDateZone(time(x), date(x), z)

TimeDate(z::Date) =
    TimeDate(Time(0), Date(z))
TimeDateZone(z::Date) =
    TimeDateZone(Time(0), Date(z), tzdefault())
TimeDateZone(z::Date, tz::TimeZone) =
    TimeDateZone(Time(0), Date(z), tz)

TimeDate(z::Time) =
    TimeDate(z, Date(now()))
TimeDateZone(z::Time) =
    TimeDateZone(Time(z), Date(now()), tzdefault())
TimeDateZone(z::Time, tz::TimeZone) =
    TimeDateZone(Time(z), Date(now()), tz)

TimeDate(z::DateTime) =
    TimeDate(Time(z), Date(z))
TimeDateZone(z::DateTime) =
    TimeDateZone(Time(z), Date(z), tzdefault())
TimeDateZone(z::DateTime, tz::TimeZone) =
    TimeDateZone(Time(z), Date(z), tz)

# ======================================= #


TimeDate(z::ZonedDateTime) =
    TimeDate(Time(z.utc_datetime), Date(z.utc_datetime))
TimeDateZone(z::ZonedDateTime) =
    TimeDateZone(Time(z.utc_datetime), Date(z.utc_datetime), z.timezone)

ZonedDateTime(tdz::TimeDateZone) =
    ZonedDateTime(date(tdz)+time(tdz), zone(tdz))
ZonedDateTime(td::TimeDate) =
    ZonedDateTime(date(td)+time(td), tzdefault())
ZonedDateTime(td::TimeDate, z::TimeZone) =
    ZonedDateTime(date(td)+time(td), z)

function DateTime(td::TimeDate)
    timeof, dateof = time(td), date(td)
    timeof = timeof - Microsecond(timeof) - Nanosecond(timeof)
    return dateof + timeof
end

function DateTime(tdz::TimeDateZone)
    return DateTime(TimeDate(td))
end

function ZonedDateTime(td::TimeDate)
    timeof, dateof = time(td), date(td)
    timeof = timeof - Microsecond(timeof) - Nanosecond(timeof)
    return ZonedDateTime(dateof + timeof, tzdefault())
end

function ZonedDateTime(td::TimeDate, zone::TimeZone)
    timeof, dateof = time(td), date(td)
    timeof = timeof - Microsecond(timeof) - Nanosecond(timeof)
    return ZonedDateTime(dateof + timeof, zone)
end

function ZonedDateTime(tdz::TimeDateZone)
    timeof, dateof = time(tdz), date(tdz)
    timeof = timeof - Microsecond(timeof) - Nanosecond(timeof)
    return ZonedDateTime(dateof + timeof, zone(tdz))
end


Date(tdz::TimeDateZone) = date(tdz)
Time(tdz::TimeDateZone) = time(tdz)
TimeZone(tdz::TimeDateZone) = zone(tdz)

Date(td::TimeDate) = date(td)
Time(td::TimeDate) = time(td)
    
