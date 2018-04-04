const DASH = '-'
const DASHSTR = "-"

function splitstring(str::AbstractString, splitat::AbstractString)
    a, z = split(str, splitat)
    return String(a), String(z)
end

timezonename(tdz::TimeDateZone) = string(tdz.in_zone)
timezonename(zdt::ZonedDateTime) = string(zdt.timezone)
timezonename(tz::TimeZone) = string(tz)

string(tdz::TimeDateZone; tzname::Bool) =
    tzname ? stringwithzone(tdz) : stringwithoffset(tdz)
    
function stringwithzone(tdz::TimeDateZone)
    return string(tdz.on_date,"T",tdz.at_time," ",tdz.in_zone)
end

function stringwithoffset(tdz::TimeDateZone)
    on_date = tdz.on_date
    at_time = tdz.at_time
    fast_time = fasttime(at_time)
    slow_time = at_time - fast_time
    slow_datetime = on_date + slow_time
    in_zone = tdz.in_zone
    zdt = ZonedDateTime(slow_datetime, in_zone)
    zdtstr = string(zdt)
    offset = zdtstr[end-5:end]
    datetime = zdtstr[1:end-6]
    timedate = TimeDate(DateTime(datetime))
    timedate = timedate + fast_time
    str = string(timedate, offset)
    return str
end

show(io::IO, td::TimeDate) = print(io, string(td))
showwithoffset(io::IO, tdz::TimeDateZone) = print(io, string(tdz))
show(td::TimeDate) = print(Base.STDOUT, string(td))
showwithoffset(tdz::TimeDateZone) = print(Base.STDOUT, string(tdz))

showwithzone(io::IO, tdz::TimeDateZone) = print(io, stringwithzone(tdz))
showwithzone(tdz::TimeDateZone) = print(Base.STDOUT, stringwithzone(tdz))

show(io::IO, tdz::TimeDateZone; tzname::Bool) =
    tzname ? showwithzone(io, tdz) : showwithoffset(io,tdz)
show(tdz::TimeDateZone; tzname::Bool) =
    tzname ? showwithzone(tdz) : showwithoffset(tdz)


splitstring(str::String, splitat::String) = map(String, split(str, splitat))

function TimeDate(str::String)
    !contains(str, "T") && throw(ErrorException("\"$str\" is not recognized as a TimeDate"))

    datepart, inttimepart, fractimepart = datetimeparts(str)

    on_date = parse(Date, datepart)
    at_time = parse(Time, inttimepart)
    at_time = fractionaltime(at_time, fractimepart)

    return TimeDate(at_time, on_date)
end

function TimeDateZone(str::String)
    !contains(str, "T") && throw(ErrorException("\"$str\" is not recognized as a TimeDateZone"))

    if contains(str, " ")
        timedatestr, tzname = splitstring(str, " ")
        timedate    = TimeDate(timedatestr)
        tz          = TimeZone(tzname)
        TimeDateZone(timedate, tz)
    else
        timedatestr = str[1:end-6]
        tzoffsetstr = str[end-5:end]
        timedate = TimeDate(timedatestr)
        tm = timedate.at_time
        dt = timedate.on_date
        tzstr = string("UTC",tzoffsetstr)
        tz = TimeZone(tzstr)
        TimeDateZone(tm, dt, tz)
    end   
end

function fractionaltime(at_time::Time, fractimepart::String)
    n = length(fractimepart)
    if n > 0
        fractime = parse(Int, fractimepart)
        if n <= 3
            delta = fld(1000,10^n)
            fractime *= delta
            at_time = at_time + Millisecond(fractime)
        elseif n <= 6
            delta = fld(1000,10^(n-3))
            fractime *= delta
            at_time = at_time + Microsecond(fractime)
        else
            delta = fld(1000,10^(n-6))
            fractime *= delta
            at_time = at_time + Nanosecond(fractime)
        end
    end
    return at_time
end

function datetimeparts(str::String)
    datepart, timepart = splitstring(str, "T")
    if contains(timepart, ".")
        inttimepart, fractimepart = splitstring(timepart, ".")
    else
        inttimepart = timepart
        fractimepart = ""
    end

    return datepart, inttimepart, fractimepart
end
