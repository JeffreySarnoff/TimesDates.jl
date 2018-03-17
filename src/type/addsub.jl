for P in (:Nanosecond, :Microsecond, :Millisecond, :Second, :Minute, :Hour)
  @eval begin

    function (+)(td::TimeDate, tp::$P)
        on_date = td.on_date
        at_time = td.at_time
        compoundtime = CompoundPeriod(at_time)
        compoundtime += tp
        compoundtime = canonical(compoundtime)
        deltadays, compoundtime = isolate_days(compoundtime)

        at_time = Time(0) + compoundtime
        on_date += deltadays

        return TimeDate(at_time, on_date)
     end

     function (-)(td::TimeDate, tp::$P)
        on_date = td.on_date
        at_time = td.at_time
        compoundtime = CompoundPeriod(at_time)
        compoundtime -= tp
        compoundtime = canonical(compoundtime)
        deltadays, compoundtime = isolate_days(compoundtime)

        at_time = Time(0) + compoundtime
        on_date += deltadays

        return TimeDate(at_time, on_date)
     end

     function (+)(tdz::TimeDateZone, tp::$P)
        td = TimeDate(tdz)
        td = td + tp

        return TimeDateZone(td.at_time, td.on_date, tdz.in_zone)
     end

     function (-)(tdz::TimeDateZone, tp::$P)
        td = TimeDate(tdz)
        td = td - tp

        return TimeDateZone(td.at_time, td.on_date, tdz.in_zone)
     end

  end
end

(+)(td::TimeDate, dy::Day) = TimeDate(td.at_time, td.on_date+dy)
(-)(td::TimeDate, dy::Day) = TimeDate(td.at_time, td.on_date-dy)
(+)(tdz::TimeDateZone, dy::Day) = TimeDateZone(tdz.at_time, tdz.on_date+dy, tdz.in_zone)
(-)(tdz::TimeDateZone, dy::Day) = TimeDateZone(tdz.at_time, tdz.on_date-dy, tdz.in_zone)

function (+)(td::TimeDate, cperiod::CompoundPeriod)
    on_date = td.on_date
    tdperiod = CompoundPeriod(td.at_time)
    tdperiod = tdperiod + cperiod
    tdperiod = canonical(tdperiod)
    days, cperiod = isolate_days(tdperiod)
    at_time = Time(0) + cperiod
    on_date += days
    return TimeDate(at_time, on_date)
end

function (-)(td::TimeDate, cperiod::CompoundPeriod)
    on_date = td.on_date
    tdperiod = CompoundPeriod(td.at_time)
    tdperiod = tdperiod - cperiod
    tdperiod = canonical(tdperiod)
    days, cperiod = isolate_days(tdperiod)
    at_time = Time(0) + cperiod
    on_date += days
    return TimeDate(at_time, on_date)
end

function (+)(tdz::TimeDateZone, cperiod::CompoundPeriod)
    td = TimeDate(tdz)
    td = td + cperiod
    return TimeDateZone(td.at_time, td.on_date, tdz.in_zone)
end

function (-)(tdz::TimeDateZone, cperiod::CompoundPeriod)
    td = TimeDate(tdz)
    td = td - cperiod
    return TimeDateZone(td.at_time, td.on_date, tdz.in_zone)
end

function (-)(tdz1::TimeDateZone, tdz2::TimeDateZone)
    tdz1 = astimezone(tdz1, tz"UTC")
    tdz2 = astimezone(tdz1, tz"UTC")
    ddate = tdz1.on_date - tdz2.on_date
    dtime = tdz1.at_time - tdz2.at_time
    delta = canonical(ddate + dtime)
    return delta
end

(+)(period::Period, td::TimeDate) = td + period
(+)(period::Period, tdz::TimeDateZone) = tdz + period
(+)(cperiod::CompoundPeriod, td::TimeDate) = td + cperiod
(+)(cperiod::CompoundPeriod, tdz::TimeDateZone) = tdz + cperiod

function (-)(atd::TimeDate, btd::TimeDate)
    atime, adate = at_time(atd), on_date(atd)
    btime, bdate = at_time(btd), on_date(btd)
    dtime = atime - btime
    ddate = adate - bdate
    delta = canonical(CompoundPeriod(ddate, dtime))
    return delta
end

(+)(atd::TimeDate, atm::Time) = (+)(atd, CompoundPeriod(atm))
(-)(atd::TimeDate, atm::Time) = (-)(atd, CompoundPeriod(atm))
(+)(atm::Time, atd::TimeDate) = (+)(atd, CompoundPeriod(atm))

(+)(atdz::TimeDateZone, atm::Time) = (+)(atdz, CompoundPeriod(atm))
(-)(atdz::TimeDateZone, atm::Time) = (-)(atdz, CompoundPeriod(atm))
(+)(atm::Time, atdz::TimeDateZone) = (+)(atdz, CompoundPeriod(atm))


(-)(atd::TimeDate, adt::DateTime) = (-)(atd, TimeDate(adt))
(-)(adt::DateTime, atd::TimeDate) = (-)(TimeDate(adt), atd)
(-)(atdz::TimeDateZone, adt::DateTime) = (-)(atdz, TimeDateZone(adt))
(-)(adt::DateTime, atdz::TimeDateZone) = (-)(TimeDateZone(adt), atdz)
(-)(atdz::TimeDateZone, adzt::ZonedDateTime) = (-)(atdz, TimeDateZone(azdt))
(-)(azdt::ZonedDateTime, atdz::TimeDateZone) = (-)(TimeDateZone(azdt), atdz)
