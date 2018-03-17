TimeDate(zdt::ZonedDateTime) = zdt.utc_datetime
TimeDate(dtm::DateTime) = TimeDate(Time(dtm), Date(dtm))
TimeDate(dt::Date) = TimeDate(Time(0), dt)
TimeDate(tm::Time) = throw(ErrorException("TimeDate(::Time) is not used"))

TimeDateZone(zdt::ZonedDateTime) =
    TimeDateZone(Time(zdt.utc_datetime), Date(zdt.utc_datetime), zdt.timezone, zdt.zone)
TimeDateZone(dtm::DateTime) = TimeDateZone(dtm, tzdefault())
TimeDateZone(dt::Date) = TimeDateZone(ZonedDateTime(DateTime(dt), tzdefault())
TimeDateZone(tm::Time) = throw(ErrorException("TimeDateZone(::Time) is not used")))


DateTime(td::TimeDate) = DateTime(td.on_date + slowtime(td.at_time))
Date(td::TimeDate) = td.on_date
Time(td::TimeDate) = td.at_time

#ZonedDateTime(td::TimeDate, tz::TimeZone) = ZonedDateTime(DateTime(td), tz)

function TimeDateZone(td::TimeDate, tz::FixedTimeZone)
    TimeDateZone(td.at_time, td.on_date, tz, tz)
end
function TimeDateZone(tm::Time, dt::Date, tz::FixedTimeZone)
    TimeDateZone(td.at_time, td.on_date, tz, tz)
end

function TimeDateZone(td::TimeDate, tz::VariableTimeZone)
    TimeDateZone(td.at_time, td.on_date, tz)
end
function TimeDateZone(tm::Time, dt::Date, tz::VariableTimeZone)
    fast_time = fasttime(tm)
    datetime  = dt + (tm - fast_time)
    zdt = ZonedDateTime(datetime, tz)
   
    tdz = TimeDateZone(Time(zdt.utc_datetime) + fast_time, Date(zdt.utc_datetime),
                       zdt.timezone, zdt.zone)
    return tdz
end

