
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

