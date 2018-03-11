const tzUTC = timezones_from_abbr("UTC")[1]
const tzLCL = localzone()

TZ_DEFAULT = [tzLCL
tzdefault() = TZ_DEFAULT[1]

function tzdefault!(x::TimeZone)
    TZ_DEFAULT[1] = x
end
