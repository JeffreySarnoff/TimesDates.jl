# Examples

## Precision Time Management

```julia
julia> using TimesDates, Dates

julia> datetime = DateTime("2001-05-10T23:59:59.999")
2001-05-10T23:59:59.999

julia> timedate = TimeDate(datetime)
2001-05-10T23:59:59.999

julia> timedate += Millisecond(1) + Nanosecond(1)
2001-05-11T00:00:00.000000001
```

## Comprised of Time Periods

```julia
julia> using TimesDates, Dates

julia> timedate = TimeDate("2018-03-09T18:29:34.04296875")
2018-03-09T18:29:34.04296875

julia> Month(timedate), Microsecond(timedate)
(3 months, 968 microseconds)

julia> month(timedate), microsecond(timedate)
(3, 968)

julia> yearmonthday(timedate)
(2018, 3, 9)
```

## Relative Dates and Days

```julia
julia> using TimesDates, TimeZones, Dates

julia> td = TimeDate("2018-05-06T08:09:10.123456789")
2018-05-06T08:09:10.123456789

julia> tdz = TimeDateZone(td, tz"America/New_York")
2018-05-06T08:09:10.123456789-04:00

julia> firstdayofweek(td), firstdayofweek(tdz)
(2018-04-30, 22018-04-30T00:00:00-04:00)

julia> dayname(td)
"Sunday"

julia> td_midnight = TimeDate(Date(td))
2018-05-06T00:00:00

julia> tonext(td_midnight, Friday)
2018-05-11T00:00:00

julia> dayname(ans)
"Friday"
```

## Temporal Type Interconversion

```julia
julia> using TimesDates, Dates

julia> date = Date("2011-02-05")
2011-02-05

julia> timedate = TimeDate(date); timedate, Date(timedate)
(2011-02-05T00:00:00, 2011-02-05)

julia> datetime = DateTime("2011-02-05T11:22:33")
2011-02-05T11:22:33

julia> timedate = TimeDate(datetime);
julia> timedate, DateTime(timedate)
(2011-02-05T11:22:33, 2011-02-05T11:22:33)
```

## Parsing Zoned Dates and Times

```julia
julia> using TimesDates, TimeZones, Dates

julia> TimeDate("1963-03-15T11:55:33.123456789")
1963-03-15T11:55:33.123456789

julia> TimeDateZone("1963-03-15T11:55:33.123456789Z")
1963-03-15T11:55:33.123456789Z

julia> datetime = DateTime("2011-05-08T12:11:15.050");
julia> zdt = ZonedDateTime(datetime, tz"Australia/Sydney")
2011-05-08T12:11:15.05+10:00

julia> tdz = TimeDateZone(zdt)
2011-05-08T02:11:15.05+10:00

julia> tdz += Microsecond(11)
2011-05-08T02:11:15.050011+10:00

julia> string(tdz)
"2011-05-08T02:11:15.050011+10:00"

julia> TimeDateZone(string(tdz))
2011-05-08T02:11:15.050011+10:00

julia> string(tdz, tzname=true)
"2011-05-08T02:11:15.050011 Australia/Sydney"

julia> TimeDateZone(string(tdz, tzname=true))
2011-05-07T16:11:15.050011+10:00
```
