function (==)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    isempty(delta)
end
str2000ns    = "2000-01-01T00:00:00.123456789"
str2000ns_ut = string(str2000ns, "+00:00")
str2000ns_ny = string(str2000ns, "-05:00")

function (!=)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    !isempty(delta)
end

function (<)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    return !isempty(delta) && signbit(delta.periods[1].value)
end

function (<=)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    return isempty(delta) || signbit(delta.periods[1].value)
end

function (>)(atd::TimeDate, btd::TimeDate)
    delta = btd - atd
    return !isempty(delta) && signbit(delta.periods[1].value)
end

function (>=)(atd::TimeDate, btd::TimeDate)
    delta = btd - atd
    return isempty(delta) || signbit(delta.periods[1].value)
end

isequal(atd::TimeDate, btd::TimeDate) = atd == btd

isless(atd::TimeDate, btd::TimeDate) = atd < btd

function (==)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    isempty(delta) && atd.at_zone === btd.at_zone
end

function (!=)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    !isempty(delta) || atd.at_zone !== btd.at_zone
end

function (<)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    return !isempty(delta) && signbit(delta.periods[1].value)
end

function (<=)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    if !isempty(delta)
        signbit(delta.periods[1].value)
    else
        atd.at_zone === btd.at_zone
    end
end

(>)(atd::TimeDateZone, btd::TimeDateZone) = (<)(bdt, atd)
(>=)(atd::TimeDateZone, btd::TimeDateZone) = (<=)(bdt, atd)

isequal(atd::TimeDateZone, btd::TimeDateZone) = atd == btd

isless(atd::TimeDateZone, btd::TimeDateZone) = atd < btd
