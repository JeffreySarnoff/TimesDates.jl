function Base.:(==)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    isempty(delta)
end
function Base.:(!=)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    !isempty(delta)
end
function Base.:(<)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    return !isempty(delta) && signbit(delta.periods[1].value)
end
function Base.:(<=)(atd::TimeDate, btd::TimeDate)
    delta = atd - btd
    return isempty(delta) || signbit(delta.periods[1].value)
end
function Base.:(>)(atd::TimeDate, btd::TimeDate)
    delta = btd - atd
    return !isempty(delta) && signbit(delta.periods[1].value)
end
function Base.:(>=)(atd::TimeDate, btd::TimeDate)
    delta = btd - atd
    return isempty(delta) || signbit(delta.periods[1].value)
end
Base.isequal(atd::TimeDate, btd::TimeDate) = atd == btd
Base.isless(atd::TimeDate, btd::TimeDate) = atd < btd

function Base.:(==)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    isempty(delta)
end
function Base.:(!=)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    !isempty(delta)
end
function Base.:(<)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    return !isempty(delta) && signbit(delta.periods[1].value)
end
function Base.:(<=)(atd::TimeDateZone, btd::TimeDateZone)
    delta = atd - btd
    return isempty(delta) || signbit(delta.periods[1].value)
end
function Base.:(>)(atd::TimeDateZone, btd::TimeDateZone)
    delta = btd - atd
    return !isempty(delta) && signbit(delta.periods[1].value)
end
function Base.:(>=)(atd::TimeDateZone, btd::TimeDateZone)
    delta = btd - atd
    return isempty(delta) || signbit(delta.periods[1].value)
end
Base.isequal(atd::TimeDateZone, btd::TimeDateZone) = atd == btd
Base.isless(atd::TimeDateZone, btd::TimeDateZone) = atd < btd
