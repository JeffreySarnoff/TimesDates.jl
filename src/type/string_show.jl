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
    return string(td.on_date,"T",td.at_time)
end

function show(io::IO, td::TimeDate)
    str = string(td)
    print(io, str)
end

function show(td::TimeDate)
    str = string(td)
    print(str)
end

timezonename(tdz::TimeDateZone) = string(tdz.in_zone)
timezonename(zdt::ZonedDateTime) = string(zdt.timezone)
timezonename(tz::TimeZone) = string(tz)

string(tdz::TimeDateZone; tzname::Bool=false) =
    tzname ? stringwithzone(tdz) : stringwithoffset(tdz)
    
function stringwithzone(tdz::TimeDateZone)
    tzname = timezonename(tdz.in_zone)
    return string(tdz.on_date,"T",tdz.at_time," ",tzname)
end

function stringwithoffset(tdz::TimeDateZone)
    offset = string(ZonedDateTime(tdz))[end-5:end]
    if offset[2:end] == "00:00"
        offset = "Z"
    end
    return string(tdz.on_date,"T",tdz.at_time,offset)
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

    on_date = parse(Date, datepart)
    at_time = parse(Time, inttimepart)
    at_time = fractionaltime(at_time, fractimepart)

    return TimeDate(at_time, on_date)
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
        tm = timedate.at_time
        dt = timedate.on_date
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
    if occursin(".", timepart)
        inttimepart, fractimepart = splitstring(timepart, ".")
    else
        inttimepart = timepart
        fractimepart = ""
    end

    return datepart, inttimepart, fractimepart
end
