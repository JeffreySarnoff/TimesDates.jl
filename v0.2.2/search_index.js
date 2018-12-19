var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Overview",
    "title": "Overview",
    "category": "page",
    "text": "TimesDates.jl provides nanosecond resolution for Time and Date and for Zoned Time and Date."
},

{
    "location": "setup/#",
    "page": "Setup",
    "title": "Setup",
    "category": "page",
    "text": ""
},

{
    "location": "setup/#install-1",
    "page": "Setup",
    "title": "install",
    "category": "section",
    "text": "This package expects Julia v1 (v0.7 is allowed)pkg> up\npkg> add TimeZones\npkg> add CompoundPeriods\npkg> add TimesDates\npkg> precompile"
},

{
    "location": "setup/#use-1",
    "page": "Setup",
    "title": "use",
    "category": "section",
    "text": "using TimesDates, CompoundPeriods, TimeZones, Dates"
},

{
    "location": "timedate_zone/#",
    "page": "Types",
    "title": "Types",
    "category": "page",
    "text": ""
},

{
    "location": "timedate_zone/#Types-1",
    "page": "Types",
    "title": "Types",
    "category": "section",
    "text": ""
},

{
    "location": "timedate_zone/#TimeDate-1",
    "page": "Types",
    "title": "TimeDate",
    "category": "section",
    "text": "nanoseconds and microseconds are understood\nomits the flexible formatting of DateTime\ntimestamps with nanosecond resolutionjulia> using TimesDates, Dates\n\njulia> td2018 = TimeDate(\"2018-01-01T00:00:00.000000001\")\n2018-01-01T00:00:00.000000001\n\njulia> td2017 = TimeDate(\"2018-01-01T00:00:00\") - Nanosecond(1)\n2017-12-31T23:59:59.999999999\n\njulia> td2017 < td2018\ntrue\n\njulia> td2018 - td2017\n2 nanoseconds\n\njulia> TimeDate(2003,4,5,9,8,7,6,5,4)\n2003-04-05T09:08:07.006005004\n"
},

{
    "location": "timedate_zone/#TimeDateZone-1",
    "page": "Types",
    "title": "TimeDateZone",
    "category": "section",
    "text": "nanoseconds and microseconds are understood\nintrazone and interzone relationships hold\nISO timestamps and Zoned timestamps availablejulia> using TimesDates, TimeZones, Dates\n\n#            ZonedDateTime is exported by TimeZones.jl\njulia> zdt = ZonedDateTime(DateTime(2012,1,21,15,25,45), tz\"America/Chicago\")\n2012-01-21T15:25:45-06:00\n\njulia> tdz = TimeDateZone(zdt)\n2012-01-21T21:25:45-06:00\n\njulia> tdz += Nanosecond(123456)\n2012-01-21T21:25:45.000123456-06:00\n\njulia> ZonedDateTime(tdz)\n2012-01-21T15:25:45-06:00"
},

{
    "location": "examples/#",
    "page": "Examples",
    "title": "Examples",
    "category": "page",
    "text": ""
},

{
    "location": "examples/#Examples-1",
    "page": "Examples",
    "title": "Examples",
    "category": "section",
    "text": ""
},

{
    "location": "examples/#Precision-Time-Management-1",
    "page": "Examples",
    "title": "Precision Time Management",
    "category": "section",
    "text": "julia> using TimesDates, Dates\n\njulia> datetime = DateTime(\"2001-05-10T23:59:59.999\")\n2001-05-10T23:59:59.999\n\njulia> timedate = TimeDate(datetime)\n2001-05-10T23:59:59.999\n\njulia> timedate += Millisecond(1) + Nanosecond(1)\n2001-05-11T00:00:00.000000001"
},

{
    "location": "examples/#Comprised-of-Time-Periods-1",
    "page": "Examples",
    "title": "Comprised of Time Periods",
    "category": "section",
    "text": "julia> using TimesDates, Dates\n\njulia> timedate = TimeDate(\"2018-03-09T18:29:34.04296875\")\n2018-03-09T18:29:34.04296875\n\njulia> Month(timedate), Microsecond(timedate)\n(3 months, 968 microseconds)\n\njulia> month(timedate), microsecond(timedate)\n(3, 968)\n\njulia> yearmonthday(timedate)\n(2018, 3, 9)"
},

{
    "location": "examples/#Relative-Dates-and-Days-1",
    "page": "Examples",
    "title": "Relative Dates and Days",
    "category": "section",
    "text": "julia> using TimesDates, TimeZones, Dates\n\njulia> td = TimeDate(\"2018-05-06T08:09:10.123456789\")\n2018-05-06T08:09:10.123456789\n\njulia> tdz = TimeDateZone(td, tz\"America/New_York\")\n2018-05-06T08:09:10.123456789-04:00\n\njulia> firstdayofweek(td), firstdayofweek(tdz)\n(2018-04-30, 22018-04-30T00:00:00-04:00)\n\njulia> dayname(td)\n\"Sunday\"\n\njulia> td_midnight = TimeDate(Date(td))\n2018-05-06T00:00:00\n\njulia> tonext(td_midnight, Friday)\n2018-05-11T00:00:00\n\njulia> dayname(ans)\n\"Friday\""
},

{
    "location": "examples/#Temporal-Type-Interconversion-1",
    "page": "Examples",
    "title": "Temporal Type Interconversion",
    "category": "section",
    "text": "julia> using TimesDates, Dates\n\njulia> date = Date(\"2011-02-05\")\n2011-02-05\n\njulia> timedate = TimeDate(date); timedate, Date(timedate)\n(2011-02-05T00:00:00, 2011-02-05)\n\njulia> datetime = DateTime(\"2011-02-05T11:22:33\")\n2011-02-05T11:22:33\n\njulia> timedate = TimeDate(datetime);\njulia> timedate, DateTime(timedate)\n(2011-02-05T11:22:33, 2011-02-05T11:22:33)"
},

{
    "location": "examples/#Parsing-Zoned-Dates-and-Times-1",
    "page": "Examples",
    "title": "Parsing Zoned Dates and Times",
    "category": "section",
    "text": "julia> using TimesDates, TimeZones, Dates\n\njulia> TimeDate(\"1963-03-15T11:55:33.123456789\")\n1963-03-15T11:55:33.123456789\n\njulia> TimeDateZone(\"1963-03-15T11:55:33.123456789Z\")\n1963-03-15T11:55:33.123456789Z\n\njulia> datetime = DateTime(\"2011-05-08T12:11:15.050\");\njulia> zdt = ZonedDateTime(datetime, tz\"Australia/Sydney\")\n2011-05-08T12:11:15.05+10:00\n\njulia> tdz = TimeDateZone(zdt)\n2011-05-08T02:11:15.05+10:00\n\njulia> tdz += Microsecond(11)\n2011-05-08T02:11:15.050011+10:00\n\njulia> string(tdz)\n\"2011-05-08T02:11:15.050011+10:00\"\n\njulia> TimeDateZone(string(tdz))\n2011-05-08T02:11:15.050011+10:00\n\njulia> string(tdz, tzname=true)\n\"2011-05-08T02:11:15.050011 Australia/Sydney\"\n\njulia> TimeDateZone(string(tdz, tzname=true))\n2011-05-07T16:11:15.050011+10:00"
},

{
    "location": "designnotes/#",
    "page": "Design Notes",
    "title": "Design Notes",
    "category": "page",
    "text": "This package provides TimeDate to hold the date and time of day given in nanoseconds (or more coarsely). And providesTimeDateZone to holds the the date and time of day in nanoseconds with a timezone. This work relies heavily on Dates and TimeZones; most of the attention to detail plays through.Dates has a Time type that has nanosecond resolution; it is not well supported, even within Dates. This Time type recognizes strings only if they are limited to millisecond resolution. Only millisecond resolved times are relevant to DateTimes. While at present limited by this millisecond barrier, TimeZones is a laudable package with active support. I expect an eventual melding of what\'s best.Here, the inner dynamics rely upon the Period types (Year .. Day, Hour, .., Nanosecond) and CompoundPeriod all provided by Dates. We distinguish slowtime, which is millisecond resolved, from a nanosecond resolved fasttime.julia> using Dates, TimesDates\n\njulia> datetime = now()\n2018-03-15T06:41:33.643\n\njulia> currentdate = Date(datetime)\n2018-03-15\n\njulia> currenttime = Time(datetime)\n06:41:33.643\n\njulia> highrestime = currenttime + Nanosecond(98765)\n06:41:33.643098765\n\njulia> date = currentdate\n2018-03-15\n\njulia> fasttime = Microsecond(highrestime) + Nanosecond(highrestime)\n98 microseconds, 765 nanoseconds\n\njulia> slowtime = highrestime - fasttime\n06:41:33.643The general approach is separate the date, slowtime, fasttime, and timezone (if appropriate), then use the date, slowtime and timezone (if appropriate) to obtain a coarse result using the facilities provided by the Date and TimeZones packages. We refine the coarse result by adding or subtracting the fasttime, as appropriate."
},

{
    "location": "acknowledgements/#",
    "page": "Acknowledgements",
    "title": "Acknowledgements",
    "category": "page",
    "text": "This work is built atop Dates and TimeZones.While both are collaborative works, a few people deserve mention:Dates: Jacob Quinn and Stefan Karpinski\nTimeZones: Curtis Vogt\nearly work on timezones:  Avik Sengupta"
},

]}
