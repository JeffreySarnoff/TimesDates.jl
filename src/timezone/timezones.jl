const TZ_UT = tz"UTC"

const TZ_LOCAL = localzone()

TimeZone(tz::FixedTimeZone) = tz
TimeZone(tz::VariableTimeZone) = tz
TimeZone(zdt::ZonedDateTime) = zdt.timezone
TimeZone(tdz::TimeDateZone) = tdz.in_zone
