function (==)(x::TimeDate, y::TimeDate)
     Date(x) === Date(y) && Time(x) === Time(y)
end
function (!=)(x::TimeDate, y::TimeDate)
     Date(x) !== Date(y) || (Date(x) == Date(y) && Time(x) != Time(y))
end
function (<)(x::TimeDate, y::TimeDate)
    dtx = DateTime(x)
    dty = DateTime(y)
    (dtx < dty) || ((dtx === dty) && (Time(x) < Time(y)))
end
function (>)(x::TimeDate, y::TimeDate)
    dtx = DateTime(x)
    dty = DateTime(y)
    (dtx > dty) || ((dtx === dty) && (Time(x) > Time(y)))
end
function (<=)(x::TimeDate, y::TimeDate)
    dtx = DateTime(x)
    dty = DateTime(y)
    (dtx < dty) || ((dtx === dty) && (Time(x) <= Time(y)))
end
function (>=)(x::TimeDate, y::TimeDate)
    dtx = DateTime(x)
    dty = DateTime(y)
    (dtx > dty) || ((dtx === dty) && (Time(x) >= Time(y)))
end

function isequal(x::TimeDate, y::TimeDate)
    xx = Microsecond(x) + Nanosecond(x)
    yy = Microsecond(y) + Nanosecond(y)
    zx = DateTime(x)
    zy = DateTime(y)
    isequal(zx, zy) && isequal(xx, yy)
end

function isless(x::TimeDate, y::TimeDate)
    xx = Microsecond(x) + Nanosecond(x)
    yy = Microsecond(y) + Nanosecond(y)
    zx = DateTime(x)
    zy = DateTime(y)
    isless(zx, zy) || (isequal(zx,zy) && isless(xx, yy))
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


function isequal(x::TimeDateZone, y::TimeDateZone)
    xx = Microsecond(x) + Nanosecond(x)
    yy = Microsecond(y) + Nanosecond(y)
    zx = ZonedDateTime(x)
    zy = ZonedDateTime(y)
    isequal(zx, zy) && isequal(xx, yy)
end

function isless(x::TimeDateZone, y::TimeDateZone)
    xx = Microsecond(x) + Nanosecond(x)
    yy = Microsecond(y) + Nanosecond(y)
    zx = ZonedDateTime(x)
    zy = ZonedDateTime(y)
    isless(zx, zy) || (isequal(zx,zy) && isless(xx, yy))
end


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
