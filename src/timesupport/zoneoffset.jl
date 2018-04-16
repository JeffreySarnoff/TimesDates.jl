#=
    this logic is developed relative to universal time
=#

offset_from_ut(tz::FixedTimeZone) = offset_seconds_from_ut(tz.offset)
offset_from_ut(zdt::ZonedDateTime) = offset_seconds_from_ut(zdt.zone.offset)
offset_from_ut(tdz::TimeDateZone) = offset_seconds_from_ut(at_zone(tdz))

offset_seconds_from_ut(offset::UTCOffset) = offset.std.value + offset.dst.value
offset_Seconds_from_ut(offset::UTCOffset) = Second(offset_seconds_from_ut(offset))

function offset_minutes_seconds_from_ut(offset::UTCOffset)
    secs = offset_seconds_from_ut(offset)
    mins, secs = fldmod(secs, SECONDS_PER_MINUTE)
    return Minute(mins), Second(secs)
end

function offset_minutes_from_ut(offset::UTCOffset)
    secs = offset_seconds_from_ut(offset)
    mins, secs = fldmod(secs, SECONDS_PER_MINUTE)
    return mins
end

offset_Minutes_from_ut(offset::UTCOffset) = Minutes(offset_minutes_from_ut(offset))

function offset_minutes_hours_from_ut(offset::UTCOffset)
    mins = offset_minutes_from_ut(offset)
    hours, mins = fldmod(mins, MINUTES_PER_HOUR)
    return Hour(hours) + Minute(mins)
end

function offset_qrtrhours_from_ut(offset::UTCOffset)
    mins = offset_minutes_from_ut(offset)
    hours, mins = fldmod(mins, MINUTES_PER_HOUR)
    qrtrhours, mins = fldmod(mins, MINUTES_PER_QRTRHOUR)
    qrtrhours += 4 * hours
    mins = qrtrhours * MINUTES_PER_QRTRHOUR
    return Minute(mins)
end

offset_hours_from_ut(offset::UTCOffset)   = div(offset_hours_from_ut, HOURS_PER_DAY)

function minutes_to_hours_minutes(x::Minute)
    hours, mins = fldmod(x.value, MINUTES_PER_HOUR)
    return Hour(hours) + Minute(mins)
end
