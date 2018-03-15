TimeDate(dt::Date, tm::Time) = TimeDate(tm, dt)
TimeDate(dtm::DateTime) = TimeDate(Time(dtm), Date(dtm))
TimeDate(dt::Date) = TimeDate(Time(0), dt)
TimeDate(tm::Time) = tzdefault() === tz"UTC" ?
                        TimeDate(tm, Date(now(Dates.UTC))) :
                        TimeDate(tm, Date(now()))
TimeDate(zdt::ZonedDateTime) = TimeDate(Time(zdt), Date(zdt))

Date(td::TimeDate) = td.on_date
Time(td::TimeDate) = td.at_time
DateTime(td::TimeDate) = td.on_date + slowtime(td.at_time)

DateTime(tm::Time) = tzdefault() === tz"UTC" ?
                        Date(now(Dates.UTC)) + slowtime(tm) :
                        Date(now()) + slowtime(tm)
# ============= #

TimeDate(tdz::TimeDateZone) = TimeDate(tdz.at_time, tdz.on_date)

function TimeDateZone(zdt::ZonedDateTime)
     dtm = DateTime(zdt)
     at_time = Time(dtm)
     on_date = Date(dtm)
     in_zone = zdt.timezone
     at_zone = zdt.zone

     return TimeDateZone(at_time, on_date, in_zone, at_zone)
end

TimeDateZone(td::TimeDate, tz::TimeZone) = TimeDateZone(ZonedDateTime(DateTime(td), tz))

TimeDateZone(tm::Time, dt::Date, tz::TimeZone) = TimeDateZone(TimeDate(tm, dt), tz)


function TimeDateZone(dtm::DateTime)
   zdt = ZonedDateTime(dtm, tzdefault())
   return TimeDateZone(zdt)
end

TimeDateZone(dt::Date) = TimeDateZone(ZonedDateTime(dt+Time(0), tzdefault()))
TimeDateZone(tm::Time) = TimeDateZone(TimeDate(tm), tzdefault())

Date(tdz::TimeDateZone) = tdz.on_date
Time(tdz::TimeDateZone) = tdz.at_time
DateTime(tdz::TimeDateZone) = tdz.on_date + slowtime(tdz.at_time)

# ============= #

convert(::Type{CompoundPeriod},x::CompoundPeriod) = x

function convert(::Type{Time}, cp::CompoundPeriod)
    cperiods = canonical(cp)
    days, cperiods = isolate_days(cperiods)
    return isempty(cperiods) ? Time(0) : Time(0) + cperiods
end

isempty(x::Dates.CompoundPeriod) = x == CompoundPeriod()

#=
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
    at_time, on_date = td.at_time, td.on_date
    at_time = at_time - Microsecond(at_time) - Nanosecond(at_time)
    return on_date + at_time
end

function DateTime(tdz::TimeDateZone)
    return DateTime(TimeDate(tdz))
end

function ZonedDateTime(td::TimeDate)
    at_time, on_date = td.at_time, td.on_date
    at_time = at_time - Microsecond(at_time) - Nanosecond(at_time)
    return ZonedDateTime(on_date + at_time, tzdefault())
end

function ZonedDateTime(td::TimeDate, zone::TimeZone)
    at_time, on_date = td.at_time, td.on_date
    at_time = at_time - Microsecond(at_time) - Nanosecond(at_time)
    return ZonedDateTime(on_date + at_time, zone)
end

function ZonedDateTime(tdz::TimeDateZone)
    at_time, on_date = tdz.at_time, tdz.on_date
    at_time = at_time - Microsecond(at_time) - Nanosecond(at_time)
    return ZonedDateTime(on_date + at_time, tdz.in_zone)
end


Date(tdz::TimeDateZone) = tdz.on_date
Time(tdz::TimeDateZone) = tdz.at_time
TimeZone(tdz::TimeDateZone) = tdz.in_zone

Date(td::TimeDate) = td.on_date
Time(td::TimeDate) = td.at_time
=#
