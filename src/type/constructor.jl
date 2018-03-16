TimeDate(dt::Date, tm::Time) = TimeDate(tm, dt)
TimeDate(dtm::DateTime) = TimeDate(Time(dtm), Date(dtm))
TimeDate(dt::Date) = TimeDate(Time(0), dt)
TimeDate(tm::Time) = tzdefault() === tz"UTC" ?
                        TimeDate(tm, Date(now(Dates.UTC))) :
                        TimeDate(tm, Date(now()))

function TimeDate(dtm::DateTime, moretime::P) where {P<:Union{Period, CompoundPeriod}}
   on_date = Date(dtm)
   at_time = Time(dtm)
   in_time = CompoundPeriod(at_time)
   in_time += moretime
   in_time = canonical(in_time)
   ndays   = Day(in_time)
   in_time -= ndays
   on_date += ndays
   return TimeDate(in_time, on_date)
end

function TimeDate(zdt::ZonedDateTime)
   tdz = TimeDateZone(zdt)
   return TimeDate(tdz)
end

function TimeDate(td::TimeDate, moretime::P) where {P<:Union{Period, CompoundPeriod}}
   on_date = Date(td)
   at_time = Time(td)
   in_time = CompoundPeriod(at_time)
   in_time += moretime
   in_time = canonical(in_time)
   ndays   = Day(in_time)
   in_time -= ndays
   on_date += ndays
   return TimeDate(in_time, on_date)
end

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

TimeDateZone(tm::Time, dt::Date, tz::TimeZone) = TimeDateZone(TimeDate(tm, dt), tz)


function TimeDateZone(td::TimeDate, tz::TimeZone)
   dtm = DateTime(td)
   fast_time = fasttime(td)
   zdt = ZonedDateTime(dtm, tz)
   td = TimeDate(zdt) + fast_time
   tdz = TimeDateZone(td.at_time, td.on_date, zdt.timezone, zdt.zone)
   return tdz
end

TimeDateZone(td::TimeDate) = TimeDateZone(td, tzdefault())


function TimeDateZone(dtm::DateTime)
   zdt = ZonedDateTime(dtm, tzdefault())
   return TimeDateZone(zdt)
end

function TimeDateZone(dtm::DateTime, tz::TimeZone)
   zdt = ZonedDateTime(dtm, tz)
   return TimeDateZone(zdt)
end

TimeDateZone(dt::Date) = TimeDateZone(ZonedDateTime(dt+Time(0), tzdefault()))
TimeDateZone(tm::Time) = TimeDateZone(TimeDate(tm), tzdefault())

Date(tdz::TimeDateZone) = tdz.on_date
Time(tdz::TimeDateZone) = tdz.at_time
DateTime(tdz::TimeDateZone) = tdz.on_date + slowtime(tdz.at_time)

function ZonedDateTime(tdz::TimeDateZone)
    datetime = tdz.on_date + slowtime(tdz.at_time)
    return ZonedDateTime(datetime, tdz.in_zone)
end

# ============= #

CompoundPeriod(dt::Date) = Year(dt) + Month(dt) + Day(dt)
CompoundPeriod(dtm::DateTime) =
   CompoundPeriod(Date(dtm)) + CompoundPeriod(Time(dtm))

CompoundPeriod(td::TimeDate) =
    CompoundPeriod(dtm.on_date) + CompoundPeriod(dtm.at_time)

convert(::Type{CompoundPeriod},x::CompoundPeriod) = x

function convert(::Type{Time}, cp::CompoundPeriod)
    cperiods = canonical(cp)
    days, cperiods = isolate_days(cperiods)
    return isempty(cperiods) ? Time(0) : Time(0) + cperiods
end

isempty(x::Dates.CompoundPeriod) = x == CompoundPeriod()

function convert(::Type{CompoundPeriod}, dt::Date)
    return Year(dt)+Month(dt)+Day(dt)
end

convert(::Type{CompoundPeriod}, tm::Time) = CompoundPeriod(tm)

convert(::Type{CompoundPeriod}, dtm::DateTime) =
    CompoundPeriod(Date(dtm)) + CompoundPeriod(Time(tm))
