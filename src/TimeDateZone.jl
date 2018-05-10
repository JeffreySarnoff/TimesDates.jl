struct TimeDateZone <: NanosecondBasis
    timestamp::TimeDate
    inzone::AkoTimeZone               # one of {FixedTimeZone, VariableTimeZone}
    atzone::FixedTimeZone

    # ensure other constructors will be give explictly

    function TimeDateZone(attime::Time, ondate::Date, inzone::VariableTimeZone, atzone::FixedTimeZone)
        tmdt = TimeDate(attime, ondate)
        return new(tmdt, inzone, atzone)
    end
    function TimeDateZone(attime::Time, ondate::Date, inzone::FixedTimeZone, atzone::FixedTimeZone)
        tmdt = TimeDate(attime, ondate)
        return new(tmdt, inzone, atzone)
    end
end

@inline timestamp(x::TimeDateZone) = x.timestamp
@inline at_time(x::TimeDateZone) = x.timestamp.attime
@inline on_date(x::TimeDateZone) = x.timestamp.ondate
@inline in_zone(x::TimeDateZone) = x.inzone
@inline at_zone(x::TimeDateZone) = x.atzone

@inline timestamp(x::ZonedDateTime) = DateTime(x)
@inline at_time(x::ZonedDateTime) = Time(DateTime(x))
@inline on_date(x::ZonedDateTime) = Date(DateTime(x))
@inline in_zone(x::ZonedDateTime) = x.timezone
@inline at_zone(x::ZonedDateTime) = x.zone

@inline timestamp(x::TimeDate) = x
@inline timestamp(x::DateTime) = x
@inline timestamp(x::Date) = x + Time(0)


TimeDateZone(x::TimeDateZone) = x
TimeDate(x::TimeDateZone) = x.timestamp

function TimeDateZone(attime::Time, ondate::Date, atzone::FixedTimeZone)
    return TimeDateZone(attime, ondate, atzone, atzone)
end

function TimeDateZone(attime::Time, ondate::Date, inzone::VariableTimeZone)
    fast_time, slow_time = fastpart(attime), slowpart(attime)
    datetime = ondate + slow_time
    zdt = ZonedDateTime(datetime, inzone)
    atzone = at_zone(zdt)
    tim, dat = timedate(zdt)
    tim = tim + fast_time
    tdz = TimeDateZone(tim, dat, inzone, atzone)
    return tdz
end

@inline function ZonedDateTime(tdz::TimeDateZone)
    datetime = DateTime(timestamp(tdz))
    inzone = in_zone(tdz)
    zdt = ZonedDateTime(datetime, inzone)
    return zdt
end

@inline function TimeDateZone(zdt::ZonedDateTime)
    tim, dat = timedate(DateTime(zdt))
    inzone = in_zone(zdt)
    atzone = at_zone(zdt)
    tdz = TimeDateZone(tim, dat, inzone, atzone)
    return tdz
end

@inline function TimeDateZone(datetime::DateTime, tzone::T, idx::Int) where {T<:AkoTimeZone}
    zdt = ZonedDateTime(datetime, tzone, idx)
    return TimeDateZone(zdt)
end

TimeDateZone(datetime::DateTime, inzone::T) where {T<:AkoTimeZone} =
    TimeDateZone(ZonedDateTime(datetime, inzone))

TimeDateZone(tmdt::TimeDate, inzone::T) where {T<:AkoTimeZone} =
    TimeDateZone(Time(tmdt), Date(tmdt), inzone)

TimeDateZone(dat::Date, inzone::T) where {T<:AkoTimeZone} =
    TimeDateZone(ZonedDateTime(dat+Time(0), inzone))


"""
    utcoffset(FixedTimeZone)

    offset from UT to LocalTime in Seconds
"""
@inline function utcoffset(tz::FixedTimeZone)
    ofs = tz.offset
    return ofs.std + ofs.dst
end

@inline utcoffset(zdt::ZonedDateTime) = utcoffset(at_zone(zdt))
@inline utcoffset(tdz::TimeDateZone) = utcoffset(at_zone(tdz))


TimeDateZone(cperiod::CompoundPeriod, tzone::T) where {T<:AkoTimeZone} =
    TimeDateZone(TimeDate(cperiod), tzone)

@inline function Date(tdz::TimeDateZone)
    timedate = timestamp(tdz)
    dt = on_date(timedate)
    return dt
end



@inline function Time(tdz::TimeDateZone)
    timedate = timestamp(tdz)
    tm = at_time(timedate)
    return tm
end

@inline function DateTime(tdz::TimeDateZone)
    timedate = timestamp(tdz)
    tm = slowpart(at_time(timedate))
    dt = on_date(timedate)
    return dt+tm
end


@inline function fastpart(tdz::TimeDateZone)
    fast_time = fastpart(at_time(tdz))
    return isempty(fast_time) ? Nanosecond(0) : fast_time
end

@inline slowpart(tdz::TimeDateZone) = slowpart(at_time(tdz))

@inline fastpart(zdt::ZonedDateTime) = Nanosecond(0)
@inline slowpart(zdt::ZonedDateTime) = Time(DateTime(zdt))
