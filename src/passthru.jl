for fn in (:yearmonthday, :yearmonth, :monthday, :dayofmonth,
           :dayofweek, :isleapyear, :daysinmonth, :daysinyear, :dayofyear, :dayname, :dayabbr,
           :dayofweekofmonth, :daysofweekinmonth, :monthname, :monthabbr,
           :quarterofyear, :dayofquarter)
    @eval $fn(td::TimeDate) = $fn(Date(td))
    @eval $fn(tdz::TimeDateZone) = $fn(Date(tdz))
end

for fn in (:firstdayofweek, :lastdayofweek, :firstdayofmonth, :lastdayofmonth,
           :firstdayofyear, :lastdayofyear, :firstdayofquarter, :lastdayofquarter)
    @eval $fn(td::TimeDate) = $fn(Date(td))
    @eval $fn(tdz::TimeDateZone) = TimeDateZone($fn(Date(tdz)),in_zone(tdz))
end

for P in (:Hour, :Minute, :Second, :Millisecond, :Microsecond, :Nanosecond)
   @eval begin
       (+)(dt::Date, period::$P) = TimeDate(dt) + period
       (-)(dt::Date, period::$P) = TimeDate(dt) - period
   end
end

