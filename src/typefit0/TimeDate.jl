abstract type NanosecondTime      <: AbstractTime   end
abstract type NanosecondTimeBase  <: NanosecondTime end  # to define Periods, CompoundPeriods
abstract type NanosecondBasis     <: NanosecondTime end  # a structural trait, inherited

struct TimeDate <: NanosecondBasis
    attime::Time
    ondate::Date

    # ensure other constructors will be give explictly

    function TimeDate(attime::Time, ondate::Date)
        return new(attime, ondate)
    end
    function TimeDate(ondate::Date, attime::Time)
        return new(attime, ondate)
    end
end

@inline at_time(x::TimeDate) = x.attime
@inline on_date(x::TimeDate) = x.ondate

@inline at_time(x::DateTime) = Time(x)
@inline on_date(x::DateTime) = Date(x)

@inline at_time(x::Time) = x
@inline at_time(x::Date) = Time(0)
@inline on_date(x::Date) = x

TimeDate(x::TimeDate) = x

TimeDate(x::DateTime) = TimeDate(at_time(x), on_date(x))
TimeDate(x::Date) = TimeDate(at_time(x), on_date(x))
TimeDate(x::Time) = TimeDate(x, on_date(Dates.now()))

@inline function TimeDate(x::ZonedDateTime)
    datetime = DateTime(x)
    return TimeDate(datetime)
end

@inline Time(x::TimeDate) = at_time(x)
@inline Date(x::TimeDate) = on_date(x)

@inline fastpart(x::Time) = Nanosecond(x) + Microsecond(x)
@inline slowpart(x::Time) = x - (Nanosecond(x) + Microsecond(x))

@inline fastpart(x::Date) = Nanosecond(0)
@inline slowpart(x::Date) = Millisecond(0)

@inline fastpart(x::DateTime) = Nanosecond(0)
@inline slowpart(x::DateTime) = Time(x)

@inline function fastpart(td::TimeDate)
    fast_time = fastpart(at_time(td))
    return isempty(fast_time) ? Nanosecond(0) : fast_time
end
@inline slowpart(x::TimeDate) = slowpart(at_time(x))

timedate(x::TimeDate) = at_time(x), on_date(x)
timedate(x::DateTime) = at_time(x), on_date(x)
timedate(x::Date) = at_time(x), on_date(x)

@inline function timedate(x::ZonedDateTime)
    datetime = DateTime(x)
    return at_time(datetime), on_date(datetime)
end

@inline function DateTime(x::TimeDate)
    tim, dat = at_time(x), on_date(x)
    tim = slowpart(tim)
    return dat + tim
end

@inline function ZonedDateTime(tmdt::TimeDate, tz::T) where {T<:AkoTimeZone}
    dtm = DateTime(tmdt)
    return ZonedDateTime(dtm, tz)
end
