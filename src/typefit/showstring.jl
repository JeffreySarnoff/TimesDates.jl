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

function string(td::TimeDate)
    return string(on_date(td),"T",at_time(td))
end

function show(io::IO, td::TimeDate)
    str = string(td)
    print(io, str)
end

function show(td::TimeDate)
    str = string(td)
    print(str)
end

timezonename(tdz::TimeDateZone) = string(tdz.inzone)
timezonename(zdt::ZonedDateTime) = string(zdt.timezone)
timezonename(tz::TimeZone) = string(tz)

string(tdz::TimeDateZone; tzname::Bool=false) =
    tzname ? stringwithzone(tdz) : stringwithoffset(tdz)

function stringwithzone(tdz::TimeDateZone)
    tzname = timezonename(tdz.inzone)
    return string(on_date(tdz),"T",at_time(tdz)," ",tzname)
end

function stringwithoffset(tdz::TimeDateZone)
    offset = string(ZonedDateTime(tdz))[end-5:end]
    if offset[2:end] == "00:00"
        offset = "Z"
    end
    return string(on_date(tdz),"T",at_time(tdz),offset)
end


function showwithoffset(io::IO, tdz::TimeDateZone)
    str = stringwithoffset(tdz)
    print(io, str)
end

function showwithoffset(tdz::TimeDateZone)
    str = stringwithoffset(tdz)
    print(str)
end

function showwithzone(io::IO, tdz::TimeDateZone)
    str = stringwithzone(tdz)
    print(io, str)
end

function showwithzone(tdz::TimeDateZone)
    str = stringwithzone(tdz)
    print(str)
end


show(io::IO, tdz::TimeDateZone; tzname::Bool=false) =
    tzname ? showwithzone(io, tdz) : showwithoffset(io,tdz)
show(tdz::TimeDateZone; tzname::Bool=false) =
    tzname ? showwithzone(tdz) : showwithoffset(tdz)


splitstring(str::String, splitat::String) = map(String, split(str, splitat))

function TimeDate(str::String)
    !occursin("T", str) && throw(ErrorException("\"$str\" is not recognized as a TimeDate"))

    datepart, inttimepart, fractimepart = datetimeparts(str)

    ondate = parse(Date, datepart)
    attime = parse(Time, inttimepart)
    attime = fractionaltime(attime, fractimepart)

    return TimeDate(attime, ondate)
end

function TimeDateZone(str::String)
    !occursin("T", str) && throw(ErrorException("\"$str\" is not recognized as a TimeDateZone"))

    if occursin(" ", str)
        timedatestr, tzname = splitstring(str, " ")
        timedate    = TimeDate(timedatestr)
        tz          = TimeZone(tzname)
        TimeDateZone(timedate, tz)
    else
        if str[end] == 'Z'
            timedatestr = str[1:end-1]
            tz = tz"UTC"
        else
            timedatestr = str[1:end-6]
            tzoffsetstr = str[end-5:end]
            tz = TimeZone(tzoffsetstr)
        end
        timedate = TimeDate(timedatestr)
        tm = timedate.attime
        dt = timedate.ondate
        TimeDateZone(tm, dt, tz)
    end
end

function fractionaltime(attime::Time, fractimepart::String)
    n = length(fractimepart)
    if n > 0
        fractime = parse(Int, fractimepart)
        if n <= 3
            delta = fld(1000,10^n)
            fractime *= delta
            attime = attime + Millisecond(fractime)
        elseif n <= 6
            delta = fld(1000,10^(n-3))
            fractime *= delta
            attime = attime + Microsecond(fractime)
        else
            delta = fld(1000,10^(n-6))
            fractime *= delta
            attime = attime + Nanosecond(fractime)
        end
    end
    return attime
end

function datetimeparts(str::String)
    datepart, timepart = splitstring(str, "T")
    if occursin(".", timepart)
        inttimepart, fractimepart = splitstring(timepart, ".")
    else
        inttimepart = timepart
        fractimepart = ""
    end

    return datepart, inttimepart, fractimepart
end
