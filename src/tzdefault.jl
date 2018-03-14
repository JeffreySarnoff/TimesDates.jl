TZ_DEFAULT = TimeZone[TZ_UT]
tzdefault() = TZ_DEFAULT[1]

function tzdefault!(x::TimeZone)
    TZ_DEFAULT[1] = x
end

function tzdefault!(x::AbstractString)
    tz = TimeZone(x)
    TZ_DEFAULT[1] = tz
end
