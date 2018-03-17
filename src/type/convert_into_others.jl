
Date(td::TimeDate) = on_date(td)

Time(td::TimeDate) = at_time(td)

DateTime(td::TimeDate) = td.on_date + slowtime(td.at_time)

DateTime(tm::Time) = tzdefault() === tz"UTC" ?
                        Date(now(Dates.UTC)) + slowtime(tm) :
                        Date(now()) + slowtime(tm)



Date(tdz::TimeDateZone) = on_date(tdz)

Time(tdz::TimeDateZone) = at_time(tdz)

DateTime(tdz::TimeDateZone) = tdz.on_date + slowtime(tdz.at_time)

function ZonedDateTime(tdz::TimeDateZone)
    datetime = tdz.on_date + slowtime(tdz.at_time)
    return ZonedDateTime(datetime, tdz.in_zone)
end

