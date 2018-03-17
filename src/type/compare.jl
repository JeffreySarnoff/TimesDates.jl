function (==)(atd::TimeDate, btd::TimeDate)
    (adt.at_time === btd.at_time) &&
    (adt.on_date === btd.on_date)
end

function (!=)(atd::TimeDate, btd::TimeDate)
    (adt.at_time !== btd.at_time) ||
    (adt.on_date !== btd.on_date)
end

function (<)(atd::TimeDate, btd::TimeDate)
    (adt.on_date < btd.on_date) ||
    ( (adt.on_date == btd.on_date) && 
      (adt.at_time < btd.at_time) )
end

function (>)(atd::TimeDate, btd::TimeDate)
    (adt.on_date > btd.on_date) ||
    ( (adt.on_date == btd.on_date) && 
      (adt.at_time > btd.at_time) )
end

function (<=)(atd::TimeDate, btd::TimeDate)
    (adt.on_date < btd.on_date) ||
    ( (adt.on_date == btd.on_date) && 
      (adt.at_time <= btd.at_time) )
end

function (>=)(atd::TimeDate, btd::TimeDate)
    (adt.on_date > btd.on_date) ||
    ( (adt.on_date == btd.on_date) && 
      (adt.at_time >= btd.at_time) )
end

isequal(atd::TimeDate, btd::TimeDate) = atd == btd

isless(atd::TimeDate, btd::TimeDate) = atd < btd


function (==)(atd::TimeDateZone, btd::TimeDateZone)
    if  (atd.at_zone === btd.at_zone)
        ( (atd.at_time === btd.at_time) &&
          (atd.on_date === btd.on_date)   )
    else 
        astimezone(atd, TZ_UT) == astimezone(btd, TZ_UT)
    end
end

function (!=)(atd::TimeDateZone, btd::TimeDateZone)
    if  (atd.at_zone === btd.at_zone)
        ( (atd.at_time !== btd.at_time) ||
          (atd.on_date !== btd.on_date)   )
    else 
        astimezone(atd, TZ_UT) != astimezone(btd, TZ_UT)
    end
end

function (<)(atd::TimeDateZone, btd::TimeDateZone)
    if  (atd.at_zone === btd.at_zone)
        ( (atd.on_date < btd.on_date) ||
          (  (atd.on_date === btd.on_date) &&
             (atd.at_time < btd.at_time)      ) )
    else 
        astimezone(atd, TZ_UT) < astimezone(btd, TZ_UT)
    end
end

function (>)(atd::TimeDateZone, btd::TimeDateZone)
    if  (atd.at_zone === btd.at_zone)
        ( (atd.on_date > btd.on_date) ||
          (  (atd.on_date === btd.on_date) &&
             (atd.at_time > btd.at_time)      ) )
    else 
        astimezone(atd, TZ_UT) > astimezone(btd, TZ_UT)
    end
end


function (<=)(atd::TimeDateZone, btd::TimeDateZone)
    if  (atd.at_zone === btd.at_zone)
        ( (atd.on_date < btd.on_date) ||
          (  (atd.on_date === btd.on_date) &&
             (atd.at_time <= btd.at_time)      ) )
    else 
        astimezone(atd, TZ_UT) <= astimezone(btd, TZ_UT)
    end
end

function (>=)(atd::TimeDateZone, btd::TimeDateZone)
    if  (atd.at_zone === btd.at_zone)
        ( (atd.on_date > btd.on_date) ||
          (  (atd.on_date === btd.on_date) &&
             (atd.at_time >= btd.at_time)      ) )
    else 
        astimezone(atd, TZ_UT) => astimezone(btd, TZ_UT)
    end
end

