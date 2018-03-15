
function string(td::TimeDate)
    return string(date(td),"T",time(td))
end

function stringwithzone(tdz::TimeDateZone)
    return string(date(tdz),"T",time(tdz)," ",zone(tdz))
end

function string(tdz::TimeDateZone)
    dateof = Date(tdz)
    timeof = Time(tdz)
    fasttimeof = fasttime(tdz)
    slowtimeof = timeof - fasttimeof
    slowdatetime = dateof + slowtimeof
    zoneof = zone(tdz)
    zdt = ZonedDateTime(slowdatetime, zoneof)
    zdtstr = string(zdt)
    offset = zdtstr[end-5:end]
    datetime = zdtstr[1:end-6]
    timedate = TimeDate(DateTime(datetime))
    timedate = timedate + fasttimeof
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

    datepart, rest = split(str, "T")
    if contains(rest, " ")
        timepart, zonepart = split(rest, " ")
    elseif contains(rest, "+")
        timepart, zonepart = split(rest, "+")
        zonepart = string("+", zonepart)
    elseif contains(rest, "-")
        timepart, zonepart = split(rest, "-")
        zonepart = string("-", zonepart)
    else
        throw(ErrorException("\"$str\" is not recognized as a TimeDate"))
    end
    
    if contains(timepart,".")
        inttimepart, fractimepart = split(timepart, ".")
    else
        inttimepart = timepart
        fractimepart = ""
    end
    
    zdtstr = string(datepart,"T",inttimepart)
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
    tm = tm + fractionaltime(tm, fractimepart)
    tdz = TimeDateZone(tm, dt, zone(tdz))
    
    return tdz
end
    
function fractionaltime(timeof::Time, fractimepart::String)
    n = length(fractimepart)
    if n > 0
        fractime = parse(Int, fractimepart)
        if n <= 3
            delta = fld(1000,10^n)
            fractime *= delta
            timeof = timeof + Millisecond(fractime)
        elseif n <= 6
            delta = fld(1000,10^(n-3))
            fractime *= delta
            timeof = timeof + Microsecond(fractime)
        else
            delta = fld(1000,10^(n-6))
            fractime *= delta
            timeof = timeof + Nanosecond(fractime)
        end
    end
    return timeof
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
