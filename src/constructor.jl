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

function TimeDate(zdt::ZonedDateTime)
    zdt = astimezone(zdt, tzdefault())
    datetime = DateTime(zdt)
    return TimeDate(datetime)
end

function TimeDateZone(zdt::ZonedDateTime)
    datetime = DateTime(zdt)
    tzone = timezone(zdt)
    return TimeDateZone(datetime, tzone)
end

function DateTime(td::TimeDate)
    timeof, dateof = time(td), date(td)
    timeof = timeof - Microsecond(timeof) - Nanosecond(timeof)
    return dateof + timeof
end

function DateTime(tdz::TimeDateZone)
    return DateTime(TimeDate(tdz))
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

Base.convert(::Type{CompoundPeriod},x::CompoundPeriod) = x

function Base.convert(::Type{Time}, cp::CompoundPeriod)
    cperiods = canonical(cp)
    days, cperiods = isolate_days(cperiods)
    return isempty(cperiods) ? Time(0) : Time(0) + cperiods
end

Base.isempty(x::Dates.CompoundPeriod) = x == CompoundPeriod()
