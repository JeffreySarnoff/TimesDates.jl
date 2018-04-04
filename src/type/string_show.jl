const DASH = '-'
const DASHSTR = "-"

if @isdefined stdout
    const StdOut = Base.stdout
else
    const StdOut = Base.STDOUT
end

function splitstring(str::AbstractString, splitat::AbstractString)
    a, z = split(str, splitat)
    return String(a), String(z)
end

timezonename(tdz::TimeDateZone) = string(tdz.in_zone)
timezonename(zdt::ZonedDateTime) = string(zdt.timezone)
timezonename(tz::TimeZone) = string(tz)

string(tdz::TimeDateZone; tzname::Bool=false) =
    tzname ? stringwithzone(tdz) : stringwithoffset(tdz)
    
function stringwithzone(tdz::TimeDateZone)
    return string(tdz.on_date,"T",tdz.at_time," ",tdz.in_zone)
end

function stringwithoffset(tdz::TimeDateZone)
    offset = string(ZonedDateTime(tdz))[end-5:end]
    return string(tdz.on_date,"T",tdz.at_time,offset)
end

show(io::IO, td::TimeDate) = print(io, string(td))
show(td::TimeDate) = print(StdOut, string(td))

showwithoffset(io::IO, tdz::TimeDateZone) = print(io, stringwithoffset(tdz))
showwithoffset(tdz::TimeDateZone) = print(StdOut, stringwithoffset(tdz))
showwithzone(io::IO, tdz::TimeDateZone) = print(io, stringwithzone(tdz))
showwithzone(tdz::TimeDateZone) = print(StdOut, stringwithzone(tdz))

show(io::IO, tdz::TimeDateZone; tzname::Bool=false) =
    tzname ? showwithzone(io, tdz) : showwithoffset(io,tdz)
show(tdz::TimeDateZone; tzname::Bool=false) =
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
