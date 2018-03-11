const tzUTC = timezones_from_abbr("UTC")[1]
const tzLCL = localzone()

TZ_DEFAULT = [tzLCL]
tzdefault() = TZ_DEFAULT[1]

function tzdefault!(x::TimeZone)
    TZ_DEFAULT[1] = x
end

function timezone_index(tzname::String)
    found = findall(x->x==tzname, timezone_names())
    length(found) == 0 && throw(DomainError("$tzname is not a recognized timezone."))
    return found[1]
end
