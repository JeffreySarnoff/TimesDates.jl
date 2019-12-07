function isless(x::TimeDate, y::TimeDate)
    x.ondate < y.ondate || (x.ondate == y.ondate && x.attime < y.attime)
end

function isequal(x::TimeDate, y::TimeDate)
    x.ondate == y.ondate && x.attime == y.attime
end

function isless(x::TimeDateZone, y::TimeDateZone)
    zx = ZonedDateTime(x)
    zy = ZonedDateTime(y)
    isless(zx,zy) && return true 
    !isequal(zx,zy) && return false
    xx = Nanosecond(Microsecond(x)) + Nanosecond(x)
    yy = Nanosecond(Microsecond(y)) + Nanosecond(y)
    return isless(xx, yy)
end

function isequal(x::TimeDateZone, y::TimeDateZone)
    zx = ZonedDateTime(x)
    zy = ZonedDateTime(y)
    !isequal(zx,zy) && return false 
    xx = Nanosecond(Microsecond(x)) + Nanosecond(x)
    yy = Nanosecond(Microsecond(y)) + Nanosecond(y)
    return isequal(xx, yy)
end


isequal(x::TimeDate, y::DateTime) = isequal(x, TimeDate(y))
isequal(x::DateTime, y::TimeDate) = isequal(TimeDate(x), y)

isless(x::TimeDate, y::DateTime) = isless(x, TimeDate(y))
isless(x::DateTime, y::TimeDate) = isless(TimeDate(x), y)


 (<)(x::TimeDate, y::DateTime) =  (<)(x, TimeDate(y))
 (>)(x::TimeDate, y::DateTime) =  (>)(x, TimeDate(y))
(<=)(x::TimeDate, y::DateTime) = (<=)(x, TimeDate(y))
(>=)(x::TimeDate, y::DateTime) = (>=)(x, TimeDate(y))
(==)(x::TimeDate, y::DateTime) = (==)(x, TimeDate(y))
(!=)(x::TimeDate, y::DateTime) = (!=)(x, TimeDate(y))

 (<)(x::DateTime, y::TimeDate) =  (<)(TimeDate(x), y)
 (>)(x::DateTime, y::TimeDate) =  (>)(TimeDate(x), y)
(<=)(x::DateTime, y::TimeDate) = (<=)(TimeDate(x), y)
(>=)(x::DateTime, y::TimeDate) = (>=)(TimeDate(x), y)
(==)(x::DateTime, y::TimeDate) = (==)(TimeDate(x), y)
(!=)(x::DateTime, y::TimeDate) = (!=)(TimeDate(x), y)

(<)(x::TimeDate, y::TimeDate) = isless(x,y)
(>)(x::TimeDate, y::TimeDate) = isless(y,x)
(<=)(x::TimeDate, y::TimeDate) = isless(x,y) || isequal(x,y)
(>=)(x::TimeDate, y::TimeDate) = isless(y,x) || isequal(x,y)
(==)(x::TimeDate, y::TimeDate) = isequal(x,y)
(!=)(x::TimeDate, y::TimeDate) = !isequal(x,y)


 (<)(x::TimeDateZone, y::TimeDateZone) = isless(x,y)
 (>)(x::TimeDateZone, y::TimeDateZone) = isless(y,x)
(<=)(x::TimeDateZone, y::TimeDateZone) = isless(x,y) || isequal(x,y)
(>=)(x::TimeDateZone, y::TimeDateZone) = isless(y,x) || isequal(x,y)
(==)(x::TimeDateZone, y::TimeDateZone) = isequal(x,y)
(!=)(x::TimeDateZone, y::TimeDateZone) = !isequal(x,y)


isequal(x::TimeDateZone, y::ZonedDateTime) = isequal(x, TimeDateZone(y))
isequal(x::ZonedDateTime, y::TimeDateZone) = isequal(TimeDateZone(x), y)

isless(x::TimeDateZone, y::ZonedDateTime) = isless(x, TimeDateZone(y))
isless(x::ZonedDateTime, y::TimeDateZone) = isless(TimeDateZone(x), y)

 (<)(x::TimeDateZone, y::ZonedDateTime) =  (<)(x, TimeDateZone(y))
 (>)(x::TimeDateZone, y::ZonedDateTime) =  (>)(x, TimeDateZone(y))
(<=)(x::TimeDateZone, y::ZonedDateTime) = (<=)(x, TimeDateZone(y))
(>=)(x::TimeDateZone, y::ZonedDateTime) = (>=)(x, TimeDateZone(y))
(==)(x::TimeDateZone, y::ZonedDateTime) = (==)(x, TimeDateZone(y))
(!=)(x::TimeDateZone, y::ZonedDateTime) = (!=)(x, TimeDateZone(y))

 (<)(x::ZonedDateTime, y::TimeDateZone) =  (<)(TimeDateZone(x), y)
 (>)(x::ZonedDateTime, y::TimeDateZone) =  (>)(TimeDateZone(x), y)
(<=)(x::ZonedDateTime, y::TimeDateZone) = (<=)(TimeDateZone(x), y)
(>=)(x::ZonedDateTime, y::TimeDateZone) = (>=)(TimeDateZone(x), y)
(==)(x::ZonedDateTime, y::TimeDateZone) = (==)(TimeDateZone(x), y)
(!=)(x::ZonedDateTime, y::TimeDateZone) = (!=)(TimeDateZone(x), y)
