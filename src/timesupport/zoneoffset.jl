#=
    this logic is developed relative to universal time 
=#

offset_from_ut(tz::FixedTimeZone) = tz.offset
offset_from_ut(zdt::ZonedDateTime) = zdt.zone.offset
offset_from_ut(tdz::TimeDateZone) = atzone(tdz)

offset_seconds_from_ut(offset::UTCOffset) = offset.std.value + offset.dst.valuea
offset_Seconds_from_ut(offset::UTCOffset) = Second(offset_seconds_from_ut(offset))

function offset_minutes_seconds_from_ut(offset::UTC0ffset)
    secs = offset_seconds_from_ut(offset)
    mins, secs = fldmod(secs, SECONDS_PER_MINUTE)
    return Minute(mins), Second(secs)
end

function offset_minutes_from_ut(offset::UTC0ffset)
    secs = offset_seconds_from_ut(offset)
    mins, secs = fldmod(secs, SECONDS_PER_MINUTE)
    return Minute(mins)
end

function offset_minutes_hours_from_ut(offset::UTC0ffset)
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

function minutes_to_hours_minutes(x::Minutes)
    hours, mins = fldmod(x.value, MINUTES_PER_HOUR)
    return Hour(hours) + Minute(mins)
end
    
function offset_qrtrhours_from_ut(offset::UTCOffset)
    secs = offset_seconds_from_ut(offset)
    mins, secs = fldmod(secs)
    qrtrhours, mins = fldmod(mins, MINUTES_PER_QRTRHOUR)
    halfhours, qrtrhours = fldmod(qrtrhours, QRTRHOURS_PER_HALFHOUR)
    hours, halfhours = fldmod(halfhours, HOURS_PER_HALFHOUR)
    return Hour(hours) + Minute(halfhours*30+ qrtrhours*4 + mins)
end

offset_Seconds_from_ut(offset::UTCOffset) = Second(offset_seconds_from_ut(offset))

offset_seconds_from_ut(offset::UTCOffset) = offset.std.value + offset.dst.value
offset_Seconds_from_ut(offset::UTCOffset) = Second(offset_seconds_from_ut(offset))

offset_seconds_from_ut(offset::UTCOffset) = offset.std.value + offset.dst.value
offset_Seconds_from_ut(offset::UTCOffset) = Second(offset_seconds_from_ut(offset))


minutes_offset_from_ut(offset::UTCOffset) = Minute(seconds_offset_from_ut(offset))
hours_offset_from_ut(offset::UTCOffset) = Hour(seconds_offset_from_ut(offset))

