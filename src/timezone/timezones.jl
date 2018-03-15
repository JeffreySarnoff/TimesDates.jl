const TZ_UT = TimeZone("UTC")
const TZ_LOCAL = localzone()


TimeZone(tz::FixedTimeZone) = tz
TimeZone(tz::VariableTimeZone) = tz
