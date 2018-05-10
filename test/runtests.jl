using Dates, CompoundPeriods, TimeZones, TimesDates
using Test

str1 = "2011-05-08T11:15:00"
str2 = "2015-08-17T21:08:11.125"
str3 = "2018-03-09T18:29:00.04296875"

dt1 = DateTime(str1)
dt2 = DateTime(str2)

td1 = TimeDate(str1)
td2 = TimeDate(str2)
td3 = TimeDate(str3)

dtz1 = ZonedDateTime(dt1, tz"UTC")
dtz2 = ZonedDateTime(dt1, tz"America/New_York")
tdz1 = TimeDateZone(td1, tz"UTC")
tdz2 = TimeDateZone(td1, tz"America/New_York")

@test string(td1) == str1
@test string(td2) == str2
@test string(td3) == str3

@test DateTime(td1) == dt1
@test DateTime(td2) == dt2

@test Year(td1) == Year(dt1)
@test Minute(td2) == Minute(dt2)

@test Minute(td1 + Minute(1)) == Minute(td1) + Minute(1)
@test Microsecond(td3 - Microsecond(1)) == Microsecond(td3) - Microsecond(1)

@test TimeDateZone(dtz1) == tdz1
@test TimeDateZone(dtz2) == tdz2

@test yearmonthday(td1) == yearmonthday(dt1)
@test lastdayofmonth(td1) == lastdayofmonth(dt1)

str2000ms    = "2000-01-01T00:00:00.123"
str2000ms_ut = string(str2000ms, "+00:00")
str2000ms_ny = string(str2000ms, "-05:00")

str2000ns    = "2000-01-01T00:00:00.123456789"
str2000ns_ut = string(str2000ns, "+00:00")
str2000ns_ny = string(str2000ns, "-05:00")

zdt2000_ut = ZonedDateTime(str2000ms_ut)
zdt2000_ny = ZonedDateTime(str2000ms_ny)

tdz2000_ut = TimeDateZone(str2000ns_ut)
tdz2000_ny = TimeDateZone(str2000ns_ny)

@test  zdt2000_ut == ZonedDateTime(tdz2000_ut)
@test  zdt2000_ny == ZonedDateTime(tdz2000_ny)


zdt = ZonedDateTime(DateTime("2011-05-08T12:11:15.050"), tz"Australia/Sydney")
tdz = TimeDateZone(zdt)
tdz += Microsecond(11)

# recasted tests from TimeZones.jl/test/


warsaw = tz"Europe/Warsaw"

normal = DateTime(2015, 1, 1, 0)   # a 24 hour day in warsaw
spring = DateTime(2015, 3, 29, 0)  # a 23 hour day in warsaw
fall = DateTime(2015, 10, 25, 0)   # a 25 hour day in warsaw

# Unary plus
@test +TimeDateZone(normal, warsaw) == TimeDateZone(normal, warsaw)

# Period arithmetic
@test TimeDateZone(normal, warsaw) + Day(1) == TimeDateZone(normal + Day(1), warsaw)
@test TimeDateZone(spring, warsaw) + Day(1) == TimeDateZone(spring + Day(1), warsaw)
@test TimeDateZone(fall, warsaw) + Day(1) == TimeDateZone(fall + Day(1), warsaw)

@test TimeDateZone(normal, warsaw) + Hour(24) == TimeDateZone(normal + Hour(24), warsaw)
@test TimeDateZone(spring, warsaw) + Hour(24) == TimeDateZone(spring + Hour(25), warsaw)
@test TimeDateZone(fall, warsaw) + Hour(24) == TimeDateZone(fall + Hour(23), warsaw)

# Do the same calculations but backwards over the transitions.
@test TimeDateZone(normal + Day(1), warsaw) - Day(1) == TimeDateZone(normal, warsaw)
@test TimeDateZone(spring + Day(1), warsaw) - Day(1) == TimeDateZone(spring, warsaw)
@test TimeDateZone(fall + Day(1), warsaw) - Day(1) == TimeDateZone(fall, warsaw)

@test TimeDateZone(normal + Day(1), warsaw) - Hour(24) == TimeDateZone(normal, warsaw)
@test TimeDateZone(spring + Day(1), warsaw) - Hour(23) == TimeDateZone(spring, warsaw)
@test TimeDateZone(fall + Day(1), warsaw) - Hour(25) == TimeDateZone(fall, warsaw)

# Ensure that arithmetic around transitions works.
@test TimeDateZone(spring, warsaw) + Hour(1) == TimeDateZone(spring + Hour(1), warsaw)
@test TimeDateZone(spring, warsaw) + Hour(2) == TimeDateZone(spring + Hour(3), warsaw)
# ambiguous
# @test TimeDateZone(fall, warsaw) + Hour(2) == TimeDateZone(fall + Hour(2), warsaw, 1)
# @test TimeDateZone(fall, warsaw) + Hour(3) == TimeDateZone(fall + Hour(2), warsaw, 2)


# CompoundPeriod canonicalization interacting with period arithmetic. Since `spring_zdt` is
# a 23 hour day this means adding `Day(1)` and `Hour(23)` are equivalent.
spring_zdt = TimeDateZone(spring, warsaw)
@test spring_zdt + Day(1) + Minute(1) == spring_zdt + Hour(23) + Minute(1)


# Non-Associativity

zdt_explicit_hourday  = ZonedDateTime(2015, 3, 31, 1, warsaw)
tdz_explicit_hourday  = TimeDateZone(zdt_explicit_hourday)
tdz_explicit_hour_day = (TimeDateZone(spring, warsaw) + Hour(24)) + Day(1)
@test zdt_explicit_hourday == ZonedDateTime(tdz_explicit_hourday)
@test tdz_explicit_hourday == tdz_explicit_hour_day

zdt_explicit_dayhour = ZonedDateTime(2015, 3, 31, 0, warsaw)
tdz_explicit_dayhour  = TimeDateZone(zdt_explicit_dayhour)
tdz_explicit_day_hour = (TimeDateZone(spring, warsaw) + Day(1)) + Hour(24)
@test zdt_explicit_dayhour == ZonedDateTime(tdz_explicit_dayhour)
@test tdz_explicit_dayhour == tdz_explicit_day_hour

zdt_implicit_hourday  = ZonedDateTime(2015, 3, 31, 0, warsaw)
tdz_implicit_hourday = TimeDateZone(zdt_implicit_hourday)
tdz_implicit_hour_day = TimeDateZone(spring, warsaw) + (Hour(24) + Day(1))
@test zdt_implicit_hourday == ZonedDateTime(tdz_implicit_hourday)
@test tdz_implicit_hourday == tdz_implicit_hour_day
tdz_implicit_hour_day = TimeDateZone(spring, warsaw) + Hour(24) + Day(1)
@test tdz_implicit_hourday == tdz_implicit_hour_day

zdt_implicit_dayhour = ZonedDateTime(2015, 3, 31, 0, warsaw)
tdz_implicit_dayhour  = TimeDateZone(zdt_implicit_dayhour)
tdz_implicit_day_hour = TimeDateZone(spring, warsaw) + Day(1) + Hour(24)
@test zdt_implicit_dayhour == ZonedDateTime(tdz_implicit_dayhour)
@test tdz_implicit_dayhour == tdz_implicit_day_hour
