
#Date(td::TimeDate) = td.on_date

#Time(td::TimeDate) = td.at_time

#DateTime(td::TimeDate) = td.on_date + slowtime(td.at_time)

#DateTime(tm::Time) = Date(now()) + slowtime(tm)


Date(tdz::TimeDateZone) = tdz.on_date

Time(tdz::TimeDateZone) = tdz.at_time

DateTime(tdz::TimeDateZone) = tdz.on_date + slowtime(tdz.at_time)

ZonedDateTime(tdz::TimeDateZone) = ZonedDateTime(DateTime(tdz), tdz.timezone)


#function ZonedDateTime(tdz::TimeDateZone)
#    datetime = tdz.on_date + slowtime(tdz.at_time)
#    return ZonedDateTime(datetime, tdz.in_zone)
#end

