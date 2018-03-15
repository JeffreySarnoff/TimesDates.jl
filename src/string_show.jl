
function string(td::TimeDate)
    return string(date(td),"T",time(td))
end

function string(tdz::TimeDateZone)
    return string(date(tdz),"T",time(tdz)," ",zone(tdz))
end

function stringcompact(tdz::TimeDateZone)
    zdt = ZonedDateTime(tdz)
    offset = zdt.zone.offset
    offsetstr = string(offset)
    return string(date(tdz),"T",time(tdz),offsetstr)
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

    dateof = parse(Date, datepart)
    timeof = parse(Time, inttimepart)
    timeof = fractionaltime(timeof, fractimepart)

    return TimeDate(timeof, dateof)
end

function TimeDateZone(str::String)
    !contains(str, "T") && throw(ErrorException("\"$str\" is not recognized as a TimeDateZone"))

    datepart, inttimepart, fractimepart, zonepart = datetimezoneparts(str)

    dateof = parse(Date, datepart)
    timeof = parse(Time, inttimepart)
    timeof = fractionaltime(timeof, fractimepart)

    zoneof = (all_timezones()[timezone_names() .== zonepart])[1]

    return TimeDateZone(timeof, dateof, zoneof)
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

function datetimezoneparts(str::String)
    datepart, inttimepart, parts = datetimeparts(str)

    if contains(parts, " ")
        fractimepart, zonepart = splitstring(parts, " ")
    else
        fractimepart = parts
        zonepart = string(tzdefault())
    end

    return datepart, inttimepart, fractimepart, zonepart
end

