for P in (:Year, :Month, :Week, :Day)
    @eval begin
        @inline $P(td::TimeDate) = $P(on_date(td))
        @inline $P(tdz::TimeDateZone) = $P(on_date(ZonedDateTime(tdz)))
    end
end
for P in (:Hour, :Minute, :Second, :Millisecond)
    @eval begin
        @inline $P(td::TimeDate) = $P(at_time(td))
        @inline $P(tdz::TimeDateZone) = $P(at_time(ZonedDateTime(tdz)))
    end
end
for P in (:Microsecond, :Nanosecond)
    @eval begin
        @inline $P(td::TimeDate) = $P(at_time(td))
        @inline $P(tdz::TimeDateZone) = $P(TimeDate(tdz))
    end
end

for P in (:Years, :Months)
    @eval begin
        @inline $P(td::TimeDate) = $P(on_date(td))
        @inline $P(tdz::TimeDateZone) = $P(on_date(ZonedDateTime(tdz)))
    end
end

Weeks(td::TimeDate) = Weeks(DateTime(td))
Weeks(tdz::TimeDateZone) = Weeks(DateTime(td))
Days(td::TimeDate) = Days(DateTime(td))
Days(tdz::TimeDateZone) = Days(DateTime(td))

for P in (:Hours, :Minutes, :Seconds, :Milliseconds)
    @eval begin
        @inline $P(td::TimeDate) = $P(at_time(td))
        @inline $P(tdz::TimeDateZone) = $P(at_time(ZonedDateTime(tdz)))
    end
end
for P in (:Microseconds, :Nanoseconds)
    @eval begin
        @inline $P(td::TimeDate) = $P(at_time(td))
        @inline $P(tdz::TimeDateZone) = $P(TimeDate(tdz))
    end
end


for (P, Q) in ((:Year,:year), (:Month,:month), (:Week,:week), (:Day,:day),
               (:Hour,:hour), (:Minute,:minute), (:Second,:second),
               (:Millisecond,:millisecond), (:Microsecond,:microsecond),
               (:Nanosecond,:nanosecond))
    @eval begin
        @inline $Q(td::TimeDate) = $P(td).value
        @inline $Q(tdz::TimeDateZone) = $P(tdz).value
    end
end

for (P, Q) in ((:Years,:years), (:Months,:months), (:Weeks,:weeks), (:Days,:days),
               (:Hours,:hours), (:Minutes,:minutes), (:Seconds,:seconds),
               (:Milliseconds,:milliseconds), (:Microseconds,:microseconds),
               (:Nanoseconds,:nanoseconds))
    @eval begin
        @inline $Q(td::TimeDate) = $P(td).value
        @inline $Q(tdz::TimeDateZone) = $P(tdz).value
    end
end
