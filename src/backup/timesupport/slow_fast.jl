"""
    fasttime(x)

    isolates the sub-millisecond elements of x

    fasttime(x) == Microsecond(x) + Nanosecond(x)
""" fasttime

"""
    slowtime(x)

    isolates the supra-microsecond elements of x as a Time

    slowtime(x) == x - fasttime(x)
""" slowtime

"""
    fastslowtimes(x)

    fasttime(x), slowtime(x)
""" fastslowtimes

macro fasttime(x)
    :(Nanosecond(nanosecond(esc($x)) + (microsecond(esc($x)) * MICROSECONDS_PER_NANOSECOND)))
end

macro slowtime(x)
    :(esc($x) - fasttime(esc($x)))
end

@inline fasttime(x::Time) =
    Nanosecond(nanosecond(x) + (microsecond(x) * MICROSECONDS_PER_NANOSECOND))
@inline slowtime(x::Time) =
    x - fasttime(x)
@inline function fastslowtimes(x::Time)
    fast_time = fasttime(x)
    slow_time = x - fast_time
    return fast_time, slow_time
end

@inline fasttime(x::DateTime) = Nanosecond(0)
@inline slowtime(x::DateTime) = Time(x)
@inline fastslowtimes(x::DateTime) = Time(x), Nanosecond(0)

@inline fasttime(x::TimeDate) = fasttime(Time(x))
@inline slowtime(x::TimeDate) = slowtime(Time(x))
@inline fastslowtimes(x::TimeDate) = fastslowtimes(Time(x))

@inline fasttime(x::ZonedDateTime) = Nanosecond(0)
@inline slowtime(x::ZonedDateTime) = Time(DateTime(x))
@inline fastslowtimes(x::ZonedDateTime) = fasttime(x), slowtime(x)

@inline fasttime(x::TimeDateZone) = fasttime(TimeDate(x))
@inline slowtime(x::TimeDateZone) = slowtime(TimeDate(x))
@inline fastslowtimes(x::TimeDateZone) = fastslowtimes(TimeDate(x))

@inline function fasttime(x::Nanosecond)
    micros, nanos = fldmod(x.value, MICROSECONDS_PER_NANOSECOND)
    millis, micros = fldmod(micros, MILLISECONDS_PER_MICROSECOND)
    return Nanosecond(nanos + (micros * MICROSECONDS_PER_NANOSECOND))
end
@inline function fasttime(x::Microsecond)
    millis, micros = fldmod(x.value, MILLISECONDS_PER_MICROSECOND)
    return Microsecond(micros)
end
@inline slowtime(x::Nanosecond) = canonical(x - fasttime(x))
@inline slowtime(x::Microsecond) = canonical(x - fasttime(x))

for P in (:Millisecond, :Second, :Minute, :Hour)
    @eval begin
        fasttime(x::$P) = Nanosecond(0)
        slowtime(x::$P) = Time(0) + x
    end
end

@inline fasttime(x::T) where {T<:AbstractTime} = fasttime(Time(x))
@inline slowtime(x::T) where {T<:AbstractTime} = slowtime(Time(x))
@inline fastslowtimes(x::T) where {T<:AbstractTime} = fastslowtimes(Time(x))

#=
fasttime(x::Nanosecond)  = Nanosecond(x) + Microsecond(x)
fasttime(x::Microsecond) = x
slowtime(x::Nanosecond)  = Time(0)
slowtime(x::Microsecond) = Time(0)

for P in (:Millisecond, :Second, :Minute, :Hour)
    @eval begin
        fasttime(x::$P) = Nanosecond(0)
        slowtime(x::$P) = Time(0) + x
    end
end
=#

@inline fastslowtimes(x::Period) = fasttime(x), slowtime(x)

fasttime(x::CompoundPeriod) =
    Nanosecond(x) + Microsecond(x)
slowtime(x::CompoundPeriod) =
    Time(0) + (x - fasttime(x))
@inline function fastslowtimes(x::CompoundPeriod)
    fast_time = fasttime(x)
    slow_time = Time(0) + (x - fast_time)
    return fast_time, slow_time
end
