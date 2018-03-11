

for P in (:Nanosecond, :Microsecond, :Millisecond, :Second, :Minute, :Hour)
  @eval begin
        
    function Base.:(+)(td::TimeDate, tp::$P)
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

     function Base.:(-)(td::TimeDate, tp::$P)
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

     function Base.:(+)(tdz::TimeDateZone, tp::$P)
        td = TimeDate(tdz)
        td = td + tp

        return TimeDateZone(time(td), date(td), zone(tdz))
     end
        
     function Base.:(-)(tdz::TimeDateZone, tp::$P)
        td = TimeDate(tdz)
        td = td - tp

        return TimeDateZone(time(td), date(td), zone(tdz))
     end

  end
end

Base.:(+)(td::TimeDate, dy::Day) = TimeDate(time(td), date(td)+dy)
Base.:(-)(td::TimeDate, dy::Day) = TimeDate(time(td), date(td)-dy)
Base.:(+)(tdz::TimeDateZone, dy::Day) = TimeDate(time(tdz), date(tdz)+dy, zone(tdz))
Base.:(-)(tdz::TimeDateZone, dy::Day) = TimeDate(time(tdz), date(tdz)-dy, zone(tdz))

function Base.:(+)(td::TimeDate, cperiod::CompoundPeriod)
    dateof = date(td)
    tdperiod = CompoundPeriod(time(td))
    tdperiod = tdperiod + cperiod
    tdperiod = canonical(tdperiod)
    days, cperiod = isolate_days(tdperiod)
    timeof = Time(0) + cperiod
    dateof += days
    return TimeDate(timeof, dateof)
end

function Base.:(-)(td::TimeDate, cperiod::CompoundPeriod)
    dateof = date(td)
    tdperiod = CompoundPeriod(time(td))
    tdperiod = tdperiod - cperiod
    tdperiod = canonical(tdperiod)
    days, cperiod = isolate_days(tdperiod)
    timeof = Time(0) + cperiod
    dateof += days
    return TimeDate(timeof, dateof)
end

(+)(td::TimeDate, tm::Time) = 
function Base.:(+)(tdz::TimeDateZone, cperiod::CompoundPeriod)
    td = TimeDate(tdz)
    td = td + cperiod
    return TimeDateZone(time(td), date(td), zone(tdz))
end

function Base.:(-)(tdz::TimeDateZone, cperiod::CompoundPeriod)
    td = TimeDate(tdz)
    td = td - cperiod
    return TimeDateZone(time(td), date(td), zone(tdz))
end

Base.:(+)(period::Period, td::TimeDate) = td + period
Base.:(+)(period::Period, tdz::TimeDateZone) = tdz + period
Base.:(+)(cperiod::CompoundPeriod, td::TimeDate) = td + cperiod
Base.:(+)(cperiod::CompoundPeriod, tdz::TimeDateZone) = tdz + cperiod

function Base.:(-)(atd::TimeDate, btd::TimeDate)
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
(-)(atd::TimeDate, atm::Time) = (-)(atd, CompoundPeriod(atm))

(+)(atdz::TimeDateZone, atm::Time) = (+)(atdz, CompoundPeriod(atm))
(-)(atdz::TimeDateZone, atm::Time) = (-)(atdz, CompoundPeriod(atm))
(+)(atm::Time, atdz::TimeDateZone) = (+)(atdz, CompoundPeriod(atm))
(-)(atdz::TimeDateZone, atm::Time) = (-)(atdz, CompoundPeriod(atm))


