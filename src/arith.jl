(+)(td::TimeDate) = td
(+)(tdz::TimeDateZone) = tdz

function (-)(td1::TimeDate, td2::TimeDate)
    dtm1 = DateTime(td1)
    dtm2 = DateTime(td2)
    dtm0 = canonical(Microsecond(td1) - Microsecond(td2) + Nanosecond(td1) - Nanosecond(td2))
    dtm = dtm1 - dtm2
    dtm += dtm0
    return sum(fldmod(dtm))
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

for P in (:Hour, :Minute, :Second, :Millisecond, :Microsecond, :Nanosecond)
    @eval begin
        function (+)(td::TimeDate, p::$P)
            tm, dt = at_time(td), on_date(td)
            cptm = canonical(CompoundPeriod(tm) + p)
            extradays = Day(cptm)
            cptm -= extradays
            dt += extradays
            tim = Time(cptm)
            return TimeDate(tim, dt)
        end
        function (-)(td::TimeDate, p::$P)
            p = -p
            return td + p
        end
    end
end

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
