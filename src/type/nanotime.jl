abstract type NanosecondTime      <: AbstractTime   end
abstract type NanosecondTimeBase  <: NanosecondTime end  # to define Periods, CompoundPeriods
abstract type NanosecondBasis     <: NanosecondTime end  # a structural trait, inherited

struct TimeDate <: NanosecondBasis
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

@inline at_time(x::TimeDate) = x.at_time
@inline on_date(x::TimeDate) = x.on_date

TimeDate(x::TimeDate) = x


struct TimeDateZone <: NanosecondBasis
    at_time::Time
    on_date::Date
    in_zone::AkoTimeZone               # one of {FixedTimeZone, VariableTimeZone}
    at_zone::FixedTimeZone

    # ensure other constructors will be give explictly

    function TimeDateZone(at_time::Time, on_date::Date, at_zone::FixedTimeZone)
        return new(at_time, on_date, at_zone, at_zone)
    end
    function TimeDateZone(at_time::Time, on_date::Date, in_zone::FixedTimeZone, at_zone::FixedTimeZone)
        return new(at_time, on_date, in_zone, at_zone)
    end
    function TimeDateZone(at_time::Time, on_date::Date, in_zone::VariableTimeZone, at_zone::FixedTimeZone)
        return new(at_time, on_date, in_zone, at_zone)
    end
end

@inline at_time(x::TimeDateZone) = x.at_time
@inline on_date(x::TimeDateZone) = x.on_date
@inline inzone(x::TimeDateZone) = x.in_zone
@inline at_zone(x::TimeDateZone) = x.at_zone

TimeDateZone(x::TimeDateZone) = x

at_time(zdt::ZonedDateTime) = Time(DateTime(zdt))
on_date(zdt::ZonedDateTime) = Date(DateTime(zdt))
at_time(dttm::DateTime) = Time(dttm)
on_date(dttm::DateTime) = Date(dttm)
