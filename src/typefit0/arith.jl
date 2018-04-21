(+)(td::TimeDate) = td
(+)(tdz::TimeDateZone) = tdz

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
