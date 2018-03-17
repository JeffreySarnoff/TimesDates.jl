TimeDate(dt::DateTime) = TimeDate(Time(dtm), Date(dtm))
DateTime(td::TimeDate) = DateTime(td.on_date + slowtime(td.at_time))

TimeDate(dt::Date) = TimeDate(Time(0), dt)
Date(td::TimeDate) = td.on_date
Time(td::TimeDate) = td.at_time

TimeDate(zdt::ZonedDateTime) = TimeDate(zdt.utc_datetime)
ZonedDateTime(td::TimeDate, tz::TimeZone) = ZonedDateTime(DateTime(td), tz)
TimeDateZone(zdt::ZonedDateTime) = 
    TimeDateZone(Time(zdt.utc_datetime), Date(zdt.utc_datetime), zdt.timezone, zdt.zone)

function TimeDateZone(zdt::ZonedDateTime)
    at_time, on_date = Time(zdt.utc_datetime), Date(zdt.utc_datetime)
    TimeDateZone(at_time, on_date, zdt.in_zone)
end

function TimeDateZone1(zdt::ZonedDateTime)
    at_time, on_date = Time(zdt.utc_datetime), Date(zdt.utc_datetime)
    TimeDateZone(at_time, on_date, zdt.at_zone)
end
function TimeDateZone2(zdt::ZonedDateTime)
    at_time, on_date = Time(zdt.utc_datetime), Date(zdt.utc_datetime)
    TimeDateZone(at_time, on_date, zdt.in_zone, zdt.at_zone)
end


function ZonedDateTime(tdz::TimeZoneDate)
    datetime = tdz.on_date + slowtime(tdz.at_time)
    ZonedDateTime(datetime, tdz.in_zone)
end

#=
TimeDate(tm:Time) = TimeDate(tm, Date(Time(0), dt)
Date(td::TimeDate) = td.on_date


TimeDate(tm::Time) = tzdefault() === tz"UTC" ?
                        TimeDate(tm, Date(now(Dates.UTC))) :
                        TimeDate(tm, Date(now()))

TimeDate(tdz::TimeDateZone) = TimeDate(tdz.at_time, tdz.on_date)

TimeDate(zdt::ZonedDateTime) = TimeDate(zdt.utc_timezone)


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
    at_time = at_time(td) # utc time
    fast_time = fasttime(at_time)
    slow_time = at_time - fast_time
    on_date = on_date(td)  # utc date
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
   at_time = td.at_time
   on_date = td.on_date
   in_zone = tz
   return TimeDateZone(at_time, on_date, in_zone)
end  
=#

#=

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

=#
