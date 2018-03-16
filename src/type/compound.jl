
CompoundPeriod(dt::Date) = Year(dt) + Month(dt) + Day(dt)
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
