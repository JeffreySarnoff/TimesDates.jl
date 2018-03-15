@inline fasttime(x::T) where {T<:NanosecTime} = Microsecond(x) + Nanosecond(x)
@inline slowtime(x::T) where {T<:NanosecTime} = Time(x) - fasttime(x)
@inline subsecs(x::T) where {T<:NanosecTime} = Millisecond(x) + fasttime(x)
@inline secstime(x::T) where {T<:NanosecTime} = Time(x) - subsecs(x)

@inline fastnanos(x::T) where {T<:NanosecTime} =
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
