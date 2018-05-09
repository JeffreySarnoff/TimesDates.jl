(+)(td::TimeDate) = td
(+)(tdz::TimeDateZone) = tdz

function TimeDate(cperiod::CompoundPeriod)
    cperiod = canonical(cperiod)
    periods = map(x->x.value, cperiod)
    return TimeDate(periods...,)
end

function (-)(td1::TimeDate, td2::TimeDate)
    tm1, dt1 = at_time(td1), on_date(td1)
    tm2, dt2 = at_time(td1), on_date(td2)
    tm = canonical(CompoundPeriod(tm1) - CompoundPeriod(tm2))
    dt = canonical(CompoundPeriod(dt1) - CompoundPeriod(dt2))
    dttm = dt + tm
    return canonical(dttm)
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

#=
function (+)(td::TimeDate, p::Period)
    cperiod = CompoundPeriod(td) + p
    return TimeDate(cperiod)
end

function (-)(td::TimeDate, p::Period)
    cperiod = CompoundPeriod(td) - p
    return TimeDate(cperiod)
end

function (+)(tdz::TimeDateZone, p::Period)
    tz = in_zone(tdz)
    td = timestamp(tdz)
    td = td + p
    return TimeDateZone(td, tz)
end

function (-)(tdz::TimeDateZone, p::Period)
    tz = in_zone(tdz)
    td = timestamp(tdz)
    td = td - p
    return TimeDateZone(td, tz)
end
=#

(+)(td::TimeDate, p1::Period, p2::Period) = td + (p1 + p2)
(-)(td::TimeDate, p1::Period, p2::Period) = td - (p1 + p2)
(+)(tdz::TimeDateZone, p1::Period, p2::Period) = tdz + (p1 + p2)
(-)(tdz::TimeDateZone, p1::Period, p2::Period) = tdz - (p1 + p2)

(+)(td::TimeDate, p1::Period, p2::Period, p3::Period) = td + (p1 + p2 + p3)
(-)(td::TimeDate, p1::Period, p2::Period, p3::Period) = td - (p1 + p2 + p3)
(+)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period) = tdz + (p1 + p2 + p3)
(-)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period) = tdz - (p1 + p2 + p3)

(+)(td::TimeDate, p1::Period, p2::Period, p3::Period, p4::Period) = td + (p1 + p2 + p3 + p4)
(-)(td::TimeDate, p1::Period, p2::Period, p3::Period, p4::Period) = td - (p1 + p2 + p3 + p4)
(+)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period) = tdz + (p1 + p2 + p3 + p4)
(-)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period) = tdz - (p1 + p2 + p3 + p4)

(+)(td::TimeDate, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period) = td + (p1 + p2 + p3 + p4 + p5)
(-)(td::TimeDate, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period) = td - (p1 + p2 + p3 + p4 + p5)
(+)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period) = tdz + (p1 + p2 + p3 + p4 + p5)
(-)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period) = tdz - (p1 + p2 + p3 + p4 + p5)

(+)(td::TimeDate, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period, p6::Period) = td + (p1 + p2 + p3 + p4 + p5 + p6)
(-)(td::TimeDate, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period, p6::Period) = td - (p1 + p2 + p3 + p4 + p5 + p6)
(+)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period, p6::Period) = tdz + (p1 + p2 + p3 + p4 + p5 + p6)
(-)(tdz::TimeDateZone, p1::Period, p2::Period, p3::Period, p4::Period, p5::Period, p6::Period) = tdz - (p1 + p2 + p3 + p4 + p5 + p6)
