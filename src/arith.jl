(+)(td::TimeDate) = td
(+)(tdz::TimeDateZone) = tdz

function (-)(td1::TimeDate, td2::TimeDate)
    Δns=at_time(td1) - at_time(td2)
    Δday=on_date(td1) - on_date(td2)
    return Nanosecond(Δday)+Δns
end

(-)(td::TimeDate, dt::DateTime) = td - TimeDate(dt)
(-)(dt::DateTime, td::TimeDate) = TimeDate(dt) - td
(-)(td::TimeDate, dt::Date) = td - TimeDate(dt)
(-)(dt::Date, td::TimeDate) = TimeDate(dt) - td

function (-)(td::TimeDate, tm::Time)
    tm_td, dt_td = at_time(td), on_date(td)
    if tm_td < tm
        dt_td -= Day(1)
        tm_td = tm_td - tm + Hour(24)
    else
        tm_td = tm_td - tm
    end
    tm_td = canonical(tm_td)
    tm = Time(tm_td)
    return TimeDate(tm, dt_td)
end



for P in (:Year, :Month, :Day)
    @eval begin
        function (+)(td::TimeDate, p::$P)
            tm, dt = at_time(td), on_date(td)
            dt = dt + p
            return TimeDate(tm, dt)
        end
        function (-)(td::TimeDate, p::$P)
            p = -p
            return td + p
        end
    end
end

function (+)(td::TimeDate, p::Union{Hour, Minute, Second, Millisecond, Microsecond, Nanosecond})
    tm, dt = at_time(td), on_date(td)
    extradays,extratime=divrem(p,oftype(p,oneunit(Day)))
    newtm = sum(promote(extratime,tm.instant))
    if newtm >= Nanosecond(oneunit(Day))
        newtm -= Nanosecond(oneunit(Day))
        extradays += 1
    elseif newtm < zero(Nanosecond)
        newtm += Nanosecond(oneunit(Day))
        extradays -= 1
    end
    return TimeDate(Time(newtm),dt+Day(extradays))
end

function (-)(td::TimeDate, p::Union{Hour, Minute, Second, Millisecond, Microsecond, Nanosecond})
    td + (-p)
end


@inline nonempty(x) = !isempty(x) ? x : Nanosecond(0)

function (-)(x::TimeDateZone, y::TimeDateZone)
    xx = Microsecond(x) + Nanosecond(x)
    xx = nonempty(xx)
    yy = Microsecond(y) + Nanosecond(y)
    yy = nonempty(yy)
    xy = xx - yy
    xy = nonempty(xy)
    zx = ZonedDateTime(x)
    zy = ZonedDateTime(y)
    zxy = zx - zy
    zxy = nonempty(zxy)
    result = zxy + xy
    result = nonempty(result)

    return canonical(result)
end

(-)(x::TimeDateZone, y::ZonedDateTime) = x - TimeDateZone(y)
(-)(x::ZonedDateTime, y::TimeDateZone) = TimeDateZone(y) - y

function(+)(tdz::TimeDateZone, p1::Period, p2::Period)
    p = p1 + p2
    return tdz + p
end

function(-)(tdz::TimeDateZone, p1::Period, p2::Period)
    p = p1 + p2
    return tdz - p
end

function(+)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period)
    p = p1 + p2 + p3
    return tdz + p
end

function(-)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period)
    p = p1 + p2 + p3
    return tdz - p
end

function(+)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period)
    p = p1 + p2 + p3 + p4
    return tdz + p
end

function(-)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period)
    p = p1 + p2 + p3 + p4
    return tdz - p
end

function(+)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period)
    p = p1 + p2 + p3 + p4 + p5
    return tdz + p
end

function(-)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period)
    p = p1 + p2 + p3 + p4 + p5
    return tdz - p
end

function(+)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period, p6::Period)
    p = p1 + p2 + p3 + p4 + p5 + p6
    return tdz + p
end

function(-)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period, p6::Period)
    p = p1 + p2 + p3 + p4 + p5 + p6
    return tdz - p
end
