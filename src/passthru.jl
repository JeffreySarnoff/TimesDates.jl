for fn in (:yearmonthday, :yearmonth, :monthday, :dayofmonth,
           :dayofweek, :isleapyear, :daysinmonth, :daysinyear, :dayofyear, :dayname, :dayabbr,
           :dayofweekofmonth, :daysofweekinmonth, :monthname, :monthabbr,
           :quarterofyear, :dayofquarter)
    @eval $fn(td::TimeDate) = $fn(Date(td))
    @eval $fn(tdz::TimeDateZone) = $fn(Date(td))
end
