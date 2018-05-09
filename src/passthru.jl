for fn in (:yearmonthday, :yearmonth, :monthday, :dayofmonth,
           :dayofweek, :isleapyear, :daysinmonth, :daysinyear, :dayofyear, :dayname, :dayabbr,
           :dayofweekofmonth, :daysofweekinmonth, :monthname, :monthabbr,
           :quarterofyear, :dayofquarter,
           :firstdayofweek, :lastdayofweek, :firstdayofmonth, :lastdayofmonth,
           :firstdayofyear, :lastdayofyear, :firstdayofquarter, :lastdayofquarter)
    @eval $fn(td::TimeDate) = $fn(Date(td))
    @eval $fn(tdz::TimeDateZone) = $fn(Date(tdz))
end
