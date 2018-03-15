

for P in (:Nanosecond, :Microsecond, :Millisecond, :Second, :Minute, :Hour)
  @eval begin

    function (+)(td::TimeDate, tp::$P)
        dateof = date(td)
        timeof = time(td)
        compoundtime = CompoundPeriod(timeof)
        compoundtime += tp
        compoundtime = canonical(compoundtime)
        deltadays, compoundtime = isolate_days(compoundtime)

        timeof = Time(0) + compoundtime
        dateof += deltadays

        return TimeDate(timeof, dateof)
     end

     function (-)(td::TimeDate, tp::$P)
        dateof = date(td)
        timeof = time(td)
        compoundtime = CompoundPeriod(timeof)
        compoundtime -= tp
        compoundtime = canonical(compoundtime)
        deltadays, compoundtime = isolate_days(compoundtime)

        timeof = Time(0) + compoundtime
        dateof += deltadays

        return TimeDate(timeof, dateof)
     end

     function (+)(tdz::TimeDateZone, tp::$P)
        td = TimeDate(tdz)
        td = td + tp

        return TimeDateZone(time(td), date(td), zone(tdz))
     end

     function (-)(tdz::TimeDateZone, tp::$P)
        td = TimeDate(tdz)
        td = td - tp

        return TimeDateZone(time(td), date(td), zone(tdz))
     end

  end
end

(+)(td::TimeDate, dy::Day) = TimeDate(time(td), date(td)+dy)
(-)(td::TimeDate, dy::Day) = TimeDate(time(td), date(td)-dy)
(+)(tdz::TimeDateZone, dy::Day) = TimeDate(time(tdz), date(tdz)+dy, zone(tdz))
(-)(tdz::TimeDateZone, dy::Day) = TimeDate(time(tdz), date(tdz)-dy, zone(tdz))

function (+)(td::TimeDate, cperiod::CompoundPeriod)
    dateof = date(td)
    tdperiod = CompoundPeriod(time(td))
    tdperiod = tdperiod + cperiod
    tdperiod = canonical(tdperiod)
    days, cperiod = isolate_days(tdperiod)
    timeof = Time(0) + cperiod
    dateof += days
    return TimeDate(timeof, dateof)
end

function (-)(td::TimeDate, cperiod::CompoundPeriod)
    dateof = date(td)
    tdperiod = CompoundPeriod(time(td))
    tdperiod = tdperiod - cperiod
    tdperiod = canonical(tdperiod)
    days, cperiod = isolate_days(tdperiod)
    timeof = Time(0) + cperiod
    dateof += days
    return TimeDate(timeof, dateof)
end

function (+)(tdz::TimeDateZone, cperiod::CompoundPeriod)
    td = TimeDate(tdz)
    td = td + cperiod
    return TimeDateZone(time(td), date(td), zone(tdz))
end

function (-)(tdz::TimeDateZone, cperiod::CompoundPeriod)
    td = TimeDate(tdz)
    td = td - cperiod
    return TimeDateZone(time(td), date(td), zone(tdz))
end

function (-)(tdz1::TimeDateZone, tdz2::TimeDateZone)
    tdz1 = astimezone(tdz1, tz"UTC")
    tdz2 = astimezone(tdz1, tz"UTC")
    ddate = date(tdz1) - date(tdz2)
    dtime = time(tdz1) - time(tdz2)
    delta = canonical(ddate + dtime)
    return delta
end

(+)(period::Period, td::TimeDate) = td + period
(+)(period::Period, tdz::TimeDateZone) = tdz + period
(+)(cperiod::CompoundPeriod, td::TimeDate) = td + cperiod
(+)(cperiod::CompoundPeriod, tdz::TimeDateZone) = tdz + cperiod

function (-)(atd::TimeDate, btd::TimeDate)
    atime, adate = time(atd), date(atd)
    btime, bdate = time(btd), date(btd)
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
(-)(atdz::TimeDateZone, adt::DateTime) = (-)(atdz, ZonedDateTime(adt))
(-)(adt::DateTime, atdz::TimeDateZone) = (-)(ZonedDateTime(adt), atdz)
(-)(atdz::TimeDateZone, adt::ZonedDateTime) =
    TimeDateZone((-)(ZonedDateTime(atdz), ZonedDateTime(adt)))
(-)(adt::ZonedDateTime, atdz::TimeDateZone) =
    TimeDateZone((-)(ZonedDateTime(adt), ZonedDateTime(atdz)))
