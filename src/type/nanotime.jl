abstract type HighResTime   <: AbstractTime end
abstract type NanosecTime   <: HighResTime end
abstract type HighResParts  <: HighResTime end

mutable struct TimeDate <: NanosecTime
    at_time::Time
    on_date::Date
end

@inline time(x::TimeDate) = x.at_time
@inline date(x::TimeDate) = x.on_date

TimeDate(x::TimeDate) = x


mutable struct TimeDateZone <: NanosecTime
    at_time::Time
    on_date::Date
    in_zone::TimeZone
    at_zone::FixedTimeZone
end

@inline time(x::TimeDateZone) = x.at_time
@inline date(x::TimeDateZone) = x.on_date
@inline timezone(x::TimeDateZone) = x.in_zone
@inline zonetime(x::TimeDateZone) = x.at_zone

TimeDateZone(x::TimeDateZone) = x
