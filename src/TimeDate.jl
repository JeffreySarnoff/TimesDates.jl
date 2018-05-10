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


function TimeDate(y::Int64, m::Int64=1, d::Int64=1,
                  h::Int64=0, mi::Int64=0, s::Int64=0, ms::Int64=0,
                  us::Int64=0, ns::Int64=0)
  fl, ns = fldmod(ns, NANOSECONDS_PER_MICROSECOND)
  us += fl
  fl, us = fldmod(us, MICROSECONDS_PER_MILLISECOND)
  ms += fl
  fl, ms = fldmod(ms, MILLISECONDS_PER_SECOND)
  s += fl
  fl, s = fldmod(s, SECONDS_PER_MINUTE)
  mi += fl
  fl, mi = fldmod(mi, MINUTES_PER_HOUR)
  h += fl
  fl, h = fldmod(h, HOURS_PER_DAY)
  d += fl
  my, m = fldmod(m, MONTHS_PER_YEAR)
  y += my
    
  dt = Date(y, m, d)
  tm = Time(h, mi, s, ms, us, ns)
  td = TimeDate(dt, tm) 
  return td
end


@inline function ZonedDateTime(tmdt::TimeDate, tz::T) where {T<:AkoTimeZone}
    dtm = DateTime(tmdt)
    return ZonedDateTime(dtm, tz)
end
