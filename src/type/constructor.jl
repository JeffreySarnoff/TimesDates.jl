
TimeDate(dtm::DateTime) = TimeDate(Time(dtm), Date(dtm))
TimeDate(dt::Date) = TimeDate(Time(0), dt)
TimeDate(tm::Time) = tzdefault() === tz"UTC" ?
                        TimeDate(tm, Date(now(Dates.UTC))) :
                        TimeDate(tm, Date(now()))

function TimeDate(tdz::TimeDateZone)
    at_time = tdz.at_time  # utc time
    on_date = tdz.on_date  # utc date
    # when the default timezone is other than UT
    # adjusting the time, date enriches locative moment
    if tzdefault() !== TZ_UT
        # convert the (tm, dt) from its UT reference into the localzone
        at_time, on_date = localtime_from_utime(at_time, on_date)
    end
    return TimeDate(at_time, on_date)
end

     
TimeDate(zdt::ZonedDateTime) = TimeDate(TimeDateZone(zdt))

Date(td::TimeDate) = ondate(td)
Time(td::TimeDate) = attime(td)
DateTime(td::TimeDate) = td.on_date + slowtime(td.at_time)
DateTime(tm::Time) = tzdefault() === tz"UTC" ?
                        Date(now(Dates.UTC)) + slowtime(tm) :
                        Date(now()) + slowtime(tm)





TimeDateZone(on_date::Date, at_time::Time, in_zone::FixedTimeZone, at_zone::FixedTimeZone) =
    TimeDateZone(at_time, on_date, in_zone, at_zone)

TimeDateZone(on_date::Date, at_time::Time, in_zone::VariableTimeZone, at_zone::FixedTimeZone) =
    TimeDateZone(at_time, on_date, in_zone, at_zone)


TimeDateZone(tm::Time, dt::Date) = TimeDateZone(Time(dtm), Date(dtm), tzdefault())

TimeDateZone(dtm::DateTime) = TimeDateZone(Time(dtm), Date(dtm))
TimeDateZone(dt::Date) = TimeDateZone(Time(0), dt)
TimeDateZone(tm::Time) = tzdefault() === tz"UTC" ?
                        TimeDateZone(tm, Date(now(Dates.UTC))) :
                        TimeDateZone(tm, Date(now()))

function TimeDateZone(at_time::Time, on_date::Date, in_zone::Z) where {Z<:AkoTimeZone}
    fast_time = fasttime(at_time)
    slow_time = at_time - fast_time
    if in_zone !== TZ_UT
        zdt = ZonedDateTime(on_date + slow_time, in_zone)
        at_zone = zdt.zone
    else
        at_zone = in_zone
    end
    return TimeDateZone(at_time, on_date, in_zone, at_zone)
end


function TimeDateZone(td::TimeDate)
    at_time = attime(td) # utc time
    fast_time = fasttime(at_time)
    slow_time = at_time - fast_time
    on_date = ondate(td)  # utc date
    in_zone = tzdefault()
    # when the default timezone is other than UT
    # this becomes the timezone to apply
    if tzdefault() !== TZ_UT
        zdt = ZonedDateTime(on_date + slow_time, in_zone)
        at_zone = zdt.zone
    else
        at_zone = in_zone
    end
    return TimeDateZone(at_time, on_date, in_zone, at_zone)
end

function TimeDateZone(td::TimeDate, tz::Z) where {Z<:AkoTimeZone}
   at_time = attime(td)
   on_date = ondate(td)
   in_zone = tz
   return TimeDateZone(at_time, on_date, in_zone)
end  
  
function TimeDateZone(zdt::ZonedDateTime)
    datetime = zdt.utc_datetime
    at_time = Time(datetime)
    on_date = Date(datetime)
    in_zone = zdt.timezone
    at_zone = zdt.zone
    return TimeDateZone(at_time, on_date, in_zone, at_zone)
end


Date(tdz::TimeDateZone) = ondate(tdz)
Time(tdz::TimeDateZone) = attime(tdz)
DateTime(tdz::TimeDateZone) = tdz.on_date + slowtime(tdz.at_time)

function ZonedDateTime(tdz::TimeDateZone)
    datetime = tdz.on_date + slowtime(tdz.at_time)
    return ZonedDateTime(datetime, tdz.in_zone)
end



#=



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


=#
