using Dates # Date, Time, DateTime, DatePeriods, TimePeriods
            # canonicalize

using Dates: AbstractTime, AbstractDateTime, CompoundPeriod

abstract type NanosecondBasis <: AbstractTime end  # a structural trait, inherited

struct TimeDate <: NanosecondBasis
    time::Time
    date::Date

    # ensure other constructors will be given explictly
    TimeDate(time::Time, date::Date) = new(time, date)
end

time(x::TimeDate) = x.time
date(x::TimeDate) = x.date

TimeDate(x::TimeDate) = x

TimeDate(date::Date, time::Time) = TimeDate(time, date)
TimeDate(x::DateTime) = TimeDate(Time(x), Date(x))
TimeDate(date::Date) = TimeDate(Time(0), date)
# DateTime(::Time) is a method error, so we do not define
# TimeDate(time::Time) = TimeDate(time, today())

function TimeDate(x::Dates.CompoundPeriod)
    dateunits = dateperiods(x)
    timeunits = timeperiods(x)
    date = isempty(dateunits) ? today() : Date(dateunits...)
    time = isempty(timeunits) ? Time(0) : Time(timeunits...)
    TimeDate(time, date)
end

Time(x::TimeDate) = time(x)
Date(x::TimeDate) = date(x)
DateTime(x::TimeDate) = DateTime(date(x), time(x))

Base.promote_rule(::Type{TimeDate}, ::Type{Time}) = TimeDate
Base.promote_rule(::Type{TimeDate}, ::Type{Date}) = TimeDate
Base.promote_rule(::Type{TimeDate}, ::Type{DateTime}) = TimeDate

Base.convert(::Type{Date}, x::TimeDate) = Date(x)
Base.convert(::Type{Time}, x::TimeDate) = Time(x)
Base.convert(::Type{DateTime}, x::TimeDate) = DateTime(x)
Base.convert(::Type{TimeDate}, x::DateTime) = TimeDate(Date(x), Time(x))

#  Period subselection from TimeDate

for P in map(Symbol, DatePeriods)
  @eval Dates.$P(td::TimeDate) = $P(date(td))     
end

for P in map(Symbol, TimePeriods)
    @eval Dates.$P(td::TimeDate) = $P(time(td))
end

# using IO
function Base.show(io::IO, x::TimeDate)
   print(io, string("TimeDate(\"", x.date, "T", x.time, "\")"))
end

timeperiods(x::CompoundPeriod) = filter(istimeperiod, canonicalize(x).periods)
dateperiods(x::CompoundPeriod) = filter(isdateperiod, canonicalize(x).periods)

istimeperiod(x) = isa(x, TimePeriod)
isdateperiod(x) = isa(x, DatePeriod)

Base.convert(::Type{CompoundPeriod}, x::Date) =
    Day(x) + Month(x) + Year(x)

Base.convert(::Type{CompoundPeriod}, x::Time) =
    Nanosecond(x) + Microsecond(x) + Millisecond(x) + Second(x) + Minute(x) + Hour(x)

Base.convert(::Type{CompoundPeriod}, x::DateTime) =
    convert(CompoundPeriod, Time(x)) + convert(CompoundPeriod, Date(x))

Base.convert(::Type{CompoundPeriod}, x::TimeDate) =
    convert(CompoundPeriod, time(x)) + convert(CompoundPeriod, date(x))

    # add Period to TimeDate

# these are given sorted from shortest period to longest
const DatePeriods = (Day, Week, Month, Quarter, Year)
const TimePeriods = (Nanosecond, Microsecond, Millisecond, Second, Minute, Hour) 
const TimeDatePeriods = (TimePeriods..., DatePeriods...)

for P in map(Symbol, DatePeriods)
  @eval begin
    Base.:(+)(td::TimeDate, dateunit::$P) = TimeDate(time(td), date(td) + dateunit)
    Base.:(+)(dateunit::$P, td::TimeDate) = TimeDate(time(td), date(td) + dateunit)
  end
end

for P in map(Symbol, DatePeriods)
  @eval begin
    function Base.:(+)(td::TimeDate, dp::$P)
        dateplus = date(td) + dp
        TimeDate(time(td), dateplus)
    end
    Base.:(+)(dp::$P, td::TimeDate) = td + dp    
  end
end

for P in map(Symbol, DatePeriods)
  @eval begin
    function Base.:(-)(td::TimeDate, dp::$P)
        dateminus = date(td) - dp
        TimeDate(time(td), dateminus)
    end
  end
end

for P in map(Symbol, TimePeriods)
  @eval begin
    function Base.:(+)(td::TimeDate, tp::$P)
        compound = canonicalize(convert(CompoundPeriod, td) + tp)
        idxtimes = findfirst(istimeperiod, compound.periods)
        if isnothing(idxtimes)
            TimeDate(Time(0), Date(compound.periods...))
        elseif idxtimes === 1
            TimeDate(Time(compound.periods...), Date(0))  # Date(0) = 0001-01-01, Year 0 does not exist
        else
            TimeDate(Time(compound.periods[idxtimes:end]...), Date(compound.periods[1:idxtimes-1]...))
        end
    end
    Base.:(+)(tp::$P, td::TimeDate) = td + tp
  end
end

for P in map(Symbol, TimePeriods)
  @eval begin
    function Base.:(-)(td::TimeDate, tp::$P)
        compound = canonicalize(convert(CompoundPeriod, td) - tp)
        idxtimes = findfirst(istimeperiod, compound.periods)
        if isnothing(idxtimes)
            TimeDate(Time(0), Date(compound.periods...))
        elseif idxtimes === 1
            TimeDate(Time(compound.periods...), Date(0))  # Date(0) = 0001-01-01, Year 0 does not exist
        else
            TimeDate(Time(compound.periods[idxtimes:end]...), Date(compound.periods[1:idxtimes-1]...))
        end
    end
  end
end

function Base.:(+)(td::TimeDate, cp::CompoundPeriod)
    result = td
    for p in reverse(canonicalize(cp).periods)
        result += p
    end
    result
end
Base.:(+)(cp::CompoundPeriod, td::TimeDate) = td + cp

function Base.:(-)(td::TimeDate, cp::CompoundPeriod)
    result = td
    for p in reverse(canonicalize(cp).periods)
        result -= p
    end
    result
end

for T in (:TimeDate, :DateTime, :Date, :Time)
    @eval begin
        function Base.:(-)(td::TimeDate, t::$T)
            result = convert(CompoundPeriod, td)
            cp = convert(CompoundPeriod, t)
            for p in reverse(cp.periods)
                result -= p
            end
            canonicalize(result)
        end
    end
end

Base.:(+)(td::TimeDate, tm::Time) = td + convert(CompoundPeriod, tm)
Base.:(+)(tm::Time, td::TimeDate) = td + convert(CompoundPeriod, tm)

Base.:(-)(td::TimeDate, tm::Time) = td - convert(CompoundPeriod, tm)

Base.:(-)(td::TimeDate, dm::DateTime) =
    canonicalize(convert(CompoundPeriod, td) - convert(CompoundPeriod, dm))
Base.:(-)(dm::DateTime, td::TimeDate) =
    canonicalize(convert(CompoundPeriod, dm) - convert(CompoundPeriod, td))
Base.:(-)(td₁::TimeDate, td₂::TimeDate) = td₁ - convert(CompoundPeriod, td₂)















Base.first(x::CompoundPeriod) = first(x.periods)

const DateTimePeriods = (Millisecond, Second, Minute, Hour, Day, Week, Month, Quarter, Year)
const SubsecondPeriods = (Nanosecond, Microsecond, Millisecond)
const SubDateTimePeriods = (Nanosecond, Microsecond)






#=
   Dates.DateFormat(format::AbstractString)
     does not have code chars 
        Microsecond (u), Nanosecond (n)
        nor does it support additional (s)s in their place
=#

const EmptyDateFormat = Dates.dateformat""
Base.isempty(df::Dates.DateFormat) = df === EmptyDateFormat

formatstring(df::Dates.DateFormat) = string(df)[12:end-1]

const millisecond_df = Dates.dateformat"sss"

const Year0 = Year(0)
const Quarter0 = Quarter(0)
const Month0 = Month(0)
const Week0 = Week(0)
const Day0 = Day(0)
const Hour0 = Hour(0)
const Minute0 = Minute(0)
const Second0 = Second(0)
const Millisecond0 = Millisecond(0)
const Microsecond0 = Microsecond(0)
const Nanosecond0  = Nanosecond(0)

function Dates.Millisecond(str::String; nmax::Int=9)
    n = min(nmax, length(str))
    if iszero(n)
        Millisecond0
    else
        Millisecond(parse(Int64,str))
    end
end

const Subsecond = Union{Dates.Millisecond, Dates.Microsecond, Dates.Nanosecond}

function subseconds(period::Type{T}, str::String; nmax::Int=9) where {T<:Subsecond}
    n = min(nmax, length(str))
    if iszero(n)
        zero(period)
    else
        period(parse(Int64,str))
    end
end


function subsecondformat(df::Dates.DateFormat)
    str = formatstring(df)
    n = length(str)
    if !occursin('s', str)
        return (df, EmptyDateFormat)

    if endswith(str, 's') || endswith(str, 'n') || endswith(str, 'u') 
        secsand, subsecs = split(str, '.')
        idx = min(3,findlast('s', subsecs ))

    else
        secsand = str
        subsecs = ""
    end

    secsand, subsecs
end



function split_dateformat(td::AbstractString, df::Dates.DateFormat)
    df[end] === 

for (C, P) in (('Y', :Year), ('y', :Year), ('m', :Month), ('U', :Month), ('d', :Day),
    ('H', :Hour), ('I', :Hour), ('M', :Minute), ('S', :Second),
    ('s', :Millisecond), ('u', :Microsecond), ('n', Nanosecond))
    @eval char2period(x::Val{$C}) = $P
end
@inline char2period(ch::Char) = char2period(Val(ch))

# from Dates.parse.jl
"""
    parse_components(str::AbstractString, df::DateFormat) -> Array{Any}
Parse the string into its components according to the directives in the `DateFormat`.
Each component will be a distinct type, typically a subtype of Period. The order of the
components will match the order of the `DatePart` directives within the `DateFormat`. The
number of components may be less than the total number of `DatePart`.
"""
@generated function parse_components(str::AbstractString, df::DateFormat)
    letters = character_codes(df)
    tokens = Type[CONVERSION_SPECIFIERS[letter] for letter in letters]

    return quote
        pos, len = firstindex(str), lastindex(str)
        val = tryparsenext_core(str, pos, len, df, true) #=raise=#
        @assert val !== nothing
        values, pos, num_parsed = val
        types = $(Expr(:tuple, tokens...))
        result = Vector{Any}(undef, num_parsed)
        for (i, typ) in enumerate(types)
            i > num_parsed && break
            result[i] = typ(values[i])  # Constructing types takes most of the time
        end
        return result
    end
end


"""
    tryparsenext_core(str::AbstractString, pos::Int, len::Int, df::DateFormat, raise=false)
Parse the string according to the directives within the `DateFormat`. Parsing will start at
character index `pos` and will stop when all directives are used or we have parsed up to
the end of the string, `len`. When a directive cannot be parsed the returned value
will be `nothing` if `raise` is false otherwise an exception will be thrown.
If successful, return a 3-element tuple `(values, pos, num_parsed)`:
* `values::Tuple`: A tuple which contains a value
  for each `DatePart` within the `DateFormat` in the order
  in which they occur. If the string ends before we finish parsing all the directives
  the missing values will be filled in with default values.
* `pos::Int`: The character index at which parsing stopped.
* `num_parsed::Int`: The number of values which were parsed and stored within `values`.
  Useful for distinguishing parsed values from default values.
"""
@generated function tryparsenext_core(str::AbstractString, pos::Int, len::Int,
    df::DateFormat, raise::Bool = false)
    directives = _directives(df)
    letters = character_codes(directives)

    tokens = Type[CONVERSION_SPECIFIERS[letter] for letter in letters]
    value_names = Symbol[genvar(t) for t in tokens]
    value_defaults = Tuple(CONVERSION_DEFAULTS[t] for t in tokens)

    # Pre-assign variables to defaults. Allows us to use `@goto done` without worrying about
    # unassigned variables.
    assign_defaults = Expr[]
    for (name, default) in zip(value_names, value_defaults)
        push!(assign_defaults, quote
            $name = $default
        end)
    end

    vi = 1
    parsers = Expr[]
    for i = 1:length(directives)
        if directives[i] <: DatePart
            name = value_names[vi]
            vi += 1
            push!(parsers, quote
                pos > len && @goto done
                let val = tryparsenext(directives[$i], str, pos, len, locale)
                    val === nothing && @goto error
                    $name, pos = val
                end
                num_parsed += 1
                directive_index += 1
            end)
        else
            push!(parsers, quote
                pos > len && @goto done
                let val = tryparsenext(directives[$i], str, pos, len, locale)
                    val === nothing && @goto error
                    delim, pos = val
                end
                directive_index += 1
            end)
        end
    end

    return quote
        directives = df.tokens
        locale::DateLocale = df.locale

        num_parsed = 0
        directive_index = 1

        $(assign_defaults...)
        $(parsers...)

        pos > len || @goto error

        @label done
        return $(Expr(:tuple, value_names...)), pos, num_parsed

        @label error
        if raise
            if directive_index > length(directives)
                throw(ArgumentError("Found extra characters at the end of date time string"))
            else
                d = directives[directive_index]
                throw(ArgumentError("Unable to parse date time. Expected directive $d at char $pos"))
            end
        end
        return nothing
    end
end



@inline at_time(x::TimeDate) = x.time
@inline on_date(x::TimeDate) = x.date

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

@inline fastpart(x::Time) = Nanosecond(rem(x.instant.value, MICROSECONDS_PER_SECOND))
@inline slowpart(x::Time) = x - fastpart(x)

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
timedate(x::Time) = at_time(x), Date(0, 12, 31)

@inline function timedate(x::ZonedDateTime)
    datetime = DateTime(x)
    return at_time(datetime), on_date(datetime)
end

@inline function DateTime(x::TimeDate)
    tim, dat = at_time(x), on_date(x)
    tim = slowpart(tim)
    return dat + tim
end

function fldmod1(n, m)
    a, b = fldmod(n, m)
    if iszero(b)
        a = a - 1
        b = m
    end
    return a, b
end

function TimeDate(y::Int64, m::Int64 = 1, d::Int64 = 1,
    h::Int64 = 0, mi::Int64 = 0, s::Int64 = 0, ms::Int64 = 0,
    us::Int64 = 0, ns::Int64 = 0)
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
    my, m = fldmod1(m, MONTHS_PER_YEAR)
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
