function (==)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    isempty(delta)
end

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
    isempty(delta)
end

function (!=)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    !isempty(delta)
end

function (<)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    return !isempty(delta) && signbit(delta.periods[1].value)
end

function (<=)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    return isempty(delta) || signbit(delta.periods[1].value)
end

function (>)(atd::TimeDateZone, btd::TimeDateZone)
    delta = btd - atd
    return !isempty(delta) && signbit(delta.periods[1].value)
end

function (>=)(atd::TimeDateZone, btd::TimeDateZone)
    delta = btd - atd
    return isempty(delta) || signbit(delta.periods[1].value)
end

isequal(atd::TimeDateZone, btd::TimeDateZone) = atd == btd

isless(atd::TimeDateZone, btd::TimeDateZone) = atd < btd
