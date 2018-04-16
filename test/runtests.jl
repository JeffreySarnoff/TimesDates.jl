using Dates, TimeZones, TimesDates
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
