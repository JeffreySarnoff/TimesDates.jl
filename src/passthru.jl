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

function tonext(td::TimeDate, dow::Int64)
   fast_time = Microsecond(td) + Nanosecond(td)
   dtm = DateTime(td)
   dtm = tonext(dtm, dow)
   tmdt = TimeDate(dtm)
   if !isempty(fast_time)
       tmdt += fast_time
   end
   return tmdt
end
tonext(td::TimeDate, dow::Int32) = tonext(td, Int64(dow))

function toprev(td::TimeDate, dow::Int64)
   fast_time = Microsecond(td) + Nanosecond(td)
   dtm = DateTime(td)
   dtm = toprev(dtm, dow)
   tmdt = TimeDate(dtm)
   if !isempty(fast_time)
       tmdt += fast_time
   end
   return tmdt
end
toprev(td::TimeDate, dow::Int32) = toprev(td, Int64(dow))

function tonext(fn::Function, td::TimeDate)
   fast_time = Microsecond(td) + Nanosecond(td)
   dtm = DateTime(td)
   dtm = tonext(fn, dtm)
   tmdt = TimeDate(dtm)
   if !isempty(fast_time)
       tmdt += fast_time
   end
   return tmdt
end

function toprev(fn::Function, td::TimeDate)
   fast_time = Microsecond(td) + Nanosecond(td)
   dtm = DateTime(td)
   dtm = toprev(fn, dtm)
   tmdt = TimeDate(dtm)
   if !isempty(fast_time)
       tmdt += fast_time
   end
   return tmdt
end


canonical(x::Time) = x
canonical(x::Date) = x
canonical(x::DateTime) = x
canonical(x::ZonedDateTime) = x
canonical(x::TimeDate) = x
canonical(x::TimeDateZone) = x

