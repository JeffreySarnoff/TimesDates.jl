
Date(td::TimeDate) = ondate(td)

Time(td::TimeDate) = attime(td)

DateTime(td::TimeDate) = td.on_date + slowtime(td.at_time)

DateTime(tm::Time) = tzdefault() === tz"UTC" ?
                        Date(now(Dates.UTC)) + slowtime(tm) :
                        Date(now()) + slowtime(tm)



Date(tdz::TimeDateZone) = ondate(tdz)

Time(tdz::TimeDateZone) = attime(tdz)

DateTime(tdz::TimeDateZone) = tdz.on_date + slowtime(tdz.at_time)

function ZonedDateTime(tdz::TimeDateZone)
    datetime = tdz.on_date + slowtime(tdz.at_time)
    return ZonedDateTime(datetime, tdz.in_zone)
end

