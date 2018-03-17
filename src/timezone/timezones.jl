const TZ_UT = tz"UTC"

const TZ_LOCAL = localzone()

TimeZone(tz::FixedTimeZone) = tz
TimeZone(tz::VariableTimeZone) = tz
