const DASH = '-'
const DASHSTR = "-"

function splitstring(str::AbstractString, splitat::AbstractString)
    a, z = split(str, splitat)
    return String(a), String(z)
end

function string(td::TimeDate)
    return string(td.on_date,"T",td.at_time)
end

function stringwithzone(tdz::TimeDateZone)
    return string(tdz.on_date,"T",tdz.at_time," ",tdz.in_zone)
end

function string(tdz::TimeDateZone)
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
show(io::IO, tdz::TimeDateZone) = print(io, string(tdz))
show(td::TimeDate) = print(Base.STDOUT, string(td))
show(tdz::TimeDateZone) = print(Base.STDOUT, string(tdz))

showcompact(io::IO, td::TimeDate) = print(io, stringcompact(td))
showcompact(io::IO, tdz::TimeDateZone) = print(io, stringcompact(tdz))
showcompact(td::TimeDate) = print(Base.STDOUT, stringcompact(td))
showcompact(tdz::TimeDateZone) = print(Base.STDOUT, stringcompact(tdz))

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
        return TimeDateZone(timedate, tz)
    end
    
    if contains(str, "+")
        timedatestr, tzoffsetstr = splitstring(str, "+")
        timedate = TimeDate(timedatestr)
        tm = Time(timedate)
        dt = Date(timedate)
        tzoffsetstr = string("UTC",tzoffsetstr)
        tz = TimeZone(tzoffsetstr)
        return TimeDateZone(tm, dt, tz)
    end
    
    timedatestr = str[1:end-6]
    timedate = TimeDate(timedatestr)
    
    tzoffsetstr   = str[end-5:end]
    tzoffsetstr = string(tzoffsetstr[2:end], ":00")
    tzoffset = parse(Time,tzoffsetstr)
    tz = TimeZone(string("UTC",tzoffsetstr))
    return TimeDateZone(timedate, tz)
end


#=
        tzoffset
        tzoffsetstr = string("+", tzoffsetstr)
        
    datepart, rest = splitstring(str, "T")
    if contains(rest, " ")
        timepart, zonepart = splitstring(rest, " ")
    elseif contains(rest, "+")
        timepart, zonepart = splitstring(rest, "+")
        zonepart = string("+", zonepart)
    elseif contains(rest, "-")
        timepart, zonepart = splitstring(rest, "-")
        zonepart = string(DASHSTR, zonepart)
    elseif contains(rest, DASHSTR)
        timepart, zonepart = splitstring(rest, DASHSTR)
        zonepart = string(DASHSTR, zonepart)
    else
        throw(ErrorException("\"$str\" is not recognized as a TimeDateZone"))
    end

    if contains(timepart,".")
        inttimepart, fractimepart = splitstring(timepart, ".")
    else
        inttimepart = timepart
        fractimepart = ""
    end

    zdtstr = string(datepart,"T",inttimepart,".000")
    if contains(rest, " ")
        tz = TimeZone(zonepart)
        zdt = ZonedDateTime(DateTime(zdtstr), tz)
        zdtstr = string(zdt)
    else
        zdtstr = string(zdtstr, zonepart)
    end

    zdt = ZonedDateTime(zdtstr)
    tdz = TimeDateZone(zdt)
    tm, dt = Time(tdz), Date(tdz)
    tm = fractionaltime(tm, fractimepart)
    tdz = TimeDateZone(tm, dt, tdz.in_zone)

    return tdz
end
=#
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
