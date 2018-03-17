# CompoundPeriod becomes iterable
Base.start(x::CompoundPeriod) = 1
Base.done(x::CompoundPeriod, state) = state > length(x.periods)
function Base.next(x::CompoundPeriod, state)
    value = x.periods[state]
    state += 1; 
    return value, state
end

Base.typemax(::Type{CompoundPeriod}) = Year
Base.typemin(::Type{CompoundPeriod}) = Nanosecond

# the extremal Periods with nonzero value
Base.typemax(x::CompoundPeriod) = typeof(x.periods[1])
Base.typemin(x::CompoundPeriod) = typeof(x.periods[end])
Base.typeminmax(x::CompoundPeriod) = typeof(x.periods[end]), typeof(x.periods[1])

Base.max(x::CompoundPeriod) = typeof(x.periods[1])
Base.min(x::CompoundPeriod) = typeof(x.periods[end])
Base.minmax(x::CompoundPeriod) = typeof(x.periods[end]), typeof(x.periods[1])

Base.sum(x::CompoundPeriod) = reduce(+, x)


"""
    YearMonthDay(::Date)

like yearmonthday() with time periods
"""
@inline YearMonthDay(dt::Date) =
   reduce( +, 
           map( (f, x)->f(x), 
                              (Year,Month,Day),
                              yearmonthday(dt) 
              )
         )

"""
    HourMinuteSecond(::Time)

like yearmonthday() with time periods
"""
@inline HourMinuteSecond(tm::Time) =
   reduce( +, 
           map( (f, x)->f(x), 
                              (Hour,Minute,Second),
                              hourminutesecond(tm) 
              )
         )

"""
    hourminutesecond(::Time)

like yearmonthday()
"""
@inline hourminutesecond(tm::Time) =
    (x->(hour(x),minute(x),second(x))).(tm)

"""
    HourMinuteSecondMillisec(::Time)

like yearmonthday() with time periods
"""
@inline HourMinuteSecondMillisec(tm::Time) =
   reduce( +, 
           map( (f, x)->f(x), 
                    (Hour,Minute,Second,Millisecond),
                    hourminutesecondmillisec(tm) ) )

"""
    hourminutesecondmillisec(::Time)

like yearmonthday()
"""
@inline hourminutesecondmillisec(tm::Time) =
    (x->(hour(x),minute(x),second(x),millisecond(x))).(tm)

"""
    MicrosecNanosec(::Time)

like yearmonthday() with time periods
"""
@inline MicrosecNanosec(tm::Time) =
   reduce( +, 
           map( (f, x)->f(x), 
                    (Microsecond, Nanosecond),
                    microsecnanosec(tm) ) )

"""
    microsecnanosec(::Time)

like yearmonthday()
"""
@inline microsecnanosec(tm::Time) =
    (x->(microsec(x), nanosec(x))).(tm)


@inline CompoundPeriod(dt::Date) = YearMonthDay(dt)

CompoundPeriod(dtm::DateTime) =
   CompoundPeriod(Date(dtm)) + CompoundPeriod(Time(dtm))

CompoundPeriod(td::TimeDate) =
    CompoundPeriod(dtm.on_date) + CompoundPeriod(dtm.at_time)

convert(::Type{CompoundPeriod},x::CompoundPeriod) = x

function convert(::Type{Time}, cp::CompoundPeriod)
    cperiods = canonical(cp)
    days, cperiods = isolate_days(cperiods)
    return isempty(cperiods) ? Time(0) : Time(0) + cperiods
end

isempty(x::Dates.CompoundPeriod) = x == CompoundPeriod()

function convert(::Type{CompoundPeriod}, dt::Date)
    return Year(dt)+Month(dt)+Day(dt)
end

convert(::Type{CompoundPeriod}, tm::Time) = CompoundPeriod(tm)

convert(::Type{CompoundPeriod}, dtm::DateTime) =
    CompoundPeriod(Date(dtm)) + CompoundPeriod(Time(tm))
