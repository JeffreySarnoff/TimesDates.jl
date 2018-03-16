"""
    fasttime(x)

    isolates the sub-millisecond elements of x

    fasttime(x) == Microsecond(x) + Nanosecond(x)
""" fasttime

"""
    slowtime(x)

    isolates the supra-microsecond elements of x

    slowtime(x) == x - fasttime(x)
""" slowtime

"""
    subsecs(x)

    isolates the sub-second elements of x

    subsecs(x) = Millisecond(x) + Microsecond(x) + Nanosecond(x)
""" subsecs

"""
    secstime(x)

    isolates the supra-millisecond elements of x

    secstime(x) = x - subsecs(x)
""" secstime

"""
    fastnanos(x)

    isolates the sub-millisecond elements of x as Nanoseconds

    fastnanos(x) = Nanosecond(1_000 * microsecond(x) + nanosecond(x))
""" fastnanos


@inline fasttime(x::T) where {T<:NanosecondTime} = Microsecond(x) + Nanosecond(x)
@inline slowtime(x::T) where {T<:NanosecondTime} = Time(x) - fasttime(x)
@inline subsecs(x::T) where {T<:NanosecondTime} = Millisecond(x) + fasttime(x)
@inline secstime(x::T) where {T<:NanosecondTime} = Time(x) - subsecs(x)

@inline fastnanos(x::T) where {T<:NanosecondTime} =
    sum(map(Nanosecond,TimesDates.fasttime(x).periods))

@inline fasttime(x::DateTime) = Nanosecond(0)
@inline slowtime(x::DateTime) = Time(x)
@inline subsecs(x::DateTime)  = Millisecond(x)
@inline secstime(x::DateTime) = slowtime(x) - subsecs(x)

@inline fasttime(x::Time) = Microsecond(x) + Nanosecond(x)
@inline slowtime(x::Time) = x - fasttime(x)
@inline subsecs(x::Time) = Millisecond(x) + fasttime(x)
@inline secstime(x::Time) = x - subsecs(x)

@inline fasttime(x::ZonedDateTime) = fasttime(DateTime(x))
@inline slowtime(x::ZonedDateTime) = slowtime(DateTime(x))
@inline subsecs(x::ZonedDateTime)  = subsecs(DateTime(x))
@inline secstime(x::ZonedDateTime) = secstime(DateTime(x))
