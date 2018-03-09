using TimesDates
using Test

str1 = "2011-05-08T11:15:00"
str2 = "2015-08-17T21:08:11.125"
str3 = "2018-03-09T18:29:00.04296875"

dt1 = DateTime(str1)
dt2 = DateTime(str2)

td1 = TimeDate(str1)
td2 = TimeDate(str2)
td3 = TimeDate(str3)

@test string(td1) == str1
@test string(td2) == str2
@test string(td3) == str3

@test DateTime(td1) == dt1
@test DateTime(td2) == dt2



