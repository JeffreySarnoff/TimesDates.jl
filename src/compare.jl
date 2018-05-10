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


isless(x::TimeDate, y::DateTime) = isless(x, TimeDate(y))
isless(x::DateTime, y::TimeDate) = isless(TimeDate(x), y)

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
