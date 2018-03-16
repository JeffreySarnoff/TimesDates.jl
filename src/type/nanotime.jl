abstract type NanosecondTime      <: AbstractTime   end
abstract type NanosecondTimeBase  <: NanosecondTime end  # to define Periods, CompoundPeriods
abstract type NanosecondBasis     <: NanosecondTime end  # a structural trait, inherited

mutable struct TimeDate <: NanosecondBasis
    at_time::Time
    on_date::Date
    
    # ensure other constructors will be give explictly
    
    function TimeDate(at_time::Time, on_date::Date)
        return new(at_time, on_date)
    end
    function TimeDate(on_date::Date, at_time::Time)
        return new(at_time, on_date)
    end
end

@inline attime(x::TimeDate) = x.at_time
@inline ondate(x::TimeDate) = x.on_date

TimeDate(x::TimeDate) = x


mutable struct TimeDateZone{Z} <: NanosecondBasis
    at_time::Time
    on_date::Date
    in_zone::Z               # Z is one of {FixedTimeZone, VariableTimeZone}
    at_zone::FixedTimeZone

    # ensure other constructors will be give explictly
    
    function TimeDateZone{Z}(at_time::Time, on_date::Date, in_zone::Z, at_zone::FixedTimeZone) where {Z<:TimeZone}
        return new{Z}(at_time, on_date, in_zone, at_zone)
    end
    function TimeDateZone{Z}(on_date::Date, at_time::Time, in_zone::Z, at_zone::FixedTimeZone) where {Z<:TimeZone}
        return new{Z}(at_time, on_date, in_zone, at_zone)
    end
end

@inline attime(x::TimeDateZone) = x.at_time
@inline ondate(x::TimeDateZone) = x.on_date
@inline inzone(x::TimeDateZone) = x.in_zone
@inline atzone(x::TimeDateZone) = x.at_zone

TimeDateZone(x::TimeDateZone) = x
