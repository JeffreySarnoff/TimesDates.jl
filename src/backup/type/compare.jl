function (==)(atd::TimeDate, btd::TimeDate)
    (at_time(atd) === at_time(btd)) &&
    (on_date(atd) === on_date(btd))
end

function (!=)(atd::TimeDate, btd::TimeDate)
    (at_time(atd) !== at_time(btd)) ||
    (on_date(atd) !== on_date(btd))
end

function (<)(atd::TimeDate, btd::TimeDate)
    (on_date(atd) < on_date(btd)) ||
    ( (on_date(atd) == on_date(btd)) &&
      (at_time(atd) < at_time(btd)) )
end

function (>)(atd::TimeDate, btd::TimeDate)
    (on_date(atd) > on_date(btd)) ||
    ( (on_date(atd) == on_date(btd)) &&
      (at_time(atd) > at_time(btd)) )
end

function (<=)(atd::TimeDate, btd::TimeDate)
    (on_date(atd) < on_date(btd)) ||
    ( (on_date(atd) == on_date(btd)) &&
      (at_time(atd) <= at_time(btd)) )
end

function (>=)(atd::TimeDate, btd::TimeDate)
    (on_date(atd) > on_date(btd)) ||
    ( (on_date(atd) == on_date(btd)) &&
      (at_time(atd) >= at_time(btd)) )
end

isequal(atd::TimeDate, btd::TimeDate) = atd == btd

isless(atd::TimeDate, btd::TimeDate) = atd < btd


function (==)(atd::TimeDateZone, btd::TimeDateZone)
    if  (at_zone(atd) === at_zone(btd))
        ( (at_time(atd) === at_time(btd)) &&
          (on_date(atd) === on_date(btd))   )
    else
        astimezone(atd, TZ_UT) == astimezone(btd, TZ_UT)
    end
end

function (!=)(atd::TimeDateZone, btd::TimeDateZone)
    if  (at_zone(atd) === at_zone(btd))
        ( (at_time(atd) !== at_time(btd)) ||
          (on_date(atd) !== on_date(btd))   )
    else
        astimezone(atd, TZ_UT) != astimezone(btd, TZ_UT)
    end
end

function (<)(atd::TimeDateZone, btd::TimeDateZone)
    if  (at_zone(atd) === at_zone(btd))
        ( (on_date(atd) < on_date(btd)) ||
          (  (on_date(atd) === on_date(btd)) &&
             (at_time(atd) < at_time(btd))      ) )
    else
        astimezone(atd, TZ_UT) < astimezone(btd, TZ_UT)
    end
end

function (>)(atd::TimeDateZone, btd::TimeDateZone)
    if  (at_zone(atd) === at_zone(btd))
        ( (on_date(atd) > on_date(btd)) ||
          (  (on_date(atd) === on_date(btd)) &&
             (at_time(atd) > at_time(btd))      ) )
    else
        astimezone(atd, TZ_UT) > astimezone(btd, TZ_UT)
    end
end


function (<=)(atd::TimeDateZone, btd::TimeDateZone)
    if  (at_zone(atd) === at_zone(btd))
        ( (on_date(atd) < on_date(btd)) ||
          (  (on_date(atd) === on_date(btd)) &&
             (at_time(atd) <= at_time(btd))      ) )
    else
        astimezone(atd, TZ_UT) <= astimezone(btd, TZ_UT)
    end
end

function (>=)(atd::TimeDateZone, btd::TimeDateZone)
    if  (at_zone(atd) === at_zone(btd))
        ( (on_date(atd) > on_date(btd)) ||
          (  (on_date(atd) === on_date(btd)) &&
             (at_time(atd) >= at_time(btd))      ) )
    else
        astimezone(atd, TZ_UT) => astimezone(btd, TZ_UT)
    end
end
