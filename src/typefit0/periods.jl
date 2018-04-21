for P in (:Year, :Month, :Week, :Day, :Hour, :Minute, :Second, :Millisecond)
    @eval begin
        @inline fastpart(p::$P) = Nanosecond(0)
        @inline slowpart(p::$P) = p
        @inline fastslow(p::$P) = Nanosecond(0), p
    end
end

for P in (:Microsecond, :Nanosecond)
    @eval begin
        @inline fastpart(p::$P) = p
        @inline slowpart(p::$P) = Millisecond(0)
        @inline fastslow(p::$P) = p, Millisecond(0)
    end
end

fastpart(cperiod::CompoundPeriod) = Nanosecond(cperiod) + Microsecond(cperiod)
slowpart(cperiod::CompoundPeriod) = cperiod - fastpart(cperiod)

@inline function fastslow(cperiod::CompoundPeriod)
    fast_part = fastpart(cperiod)
    slow_part = cperiod - fast_part
    return fast_part, slow_part
end

@inline function fastslow(x)
    tm = Time(x)
    fast_time = fastpart(tm)
    slow_time = tm - fast_time
    return fast_time, slow_time
end

function CompoundPeriod(x::TimeDate)
    tim, dat = timedate(x)
    fast_time = fastpart(tim)
    slow_time = slowpart(tim)
    tm = CompoundPeriod(slow_time) + fast_time
    dt = CompoundPeriod(dat)
    return dt + tm
end

function CompoundPeriod(x::TimeDateZone)
    tim, dat = timedate(x)
    fast_time = fastpart(tim)
    slow_time = slowpart(tim)
    tm = CompoundPeriod(slow_time) + fast_time
    dt = CompoundPeriod(dat)
    return dt + tm
end

function (+)(x::TimeDate, y::Period)
    tim, dat = timedate(x)
    fasttime, slowtime = fastpart(tim), slowpart(tim)
    fastperiod, slowperiod = fastslow(y)
    fasttime, lessfast = fastslow(fasttime + fastperiod)
    slowtime = slowtime + lessfast
    datetime = dat + slowtime
    timedate = TimeDate(datetime)
    timedate = timedate + fasttime
    return timedate
end

function (-)(x::TimeDate, y::Period)
    return x + (-y)
end

(+)(y::Period, x::TimeDate) = x + y

function (+)(x::TimeDate, z::CompoundPeriod)
    result = x
    for period in z
        result += period
    end
    result = canonical(result)
    return result
end

function (-)(x::TimeDate, z::CompoundPeriod)
    result = x
    for period in z
        result -= period
    end
    result = canonical(result)
    return result
end

(+)(y::CompoundPeriod, x::TimeDate) = x + y

function (+)(x::TimeDateZone, y::Period)
    fast_part, slow_part = fastslow(y)
    zdt = ZonedDateTime(x)
    fast_time = at_time(x) - at_time(zdt)
    fast_time += fast_part
    zdt = zdt + slow_part
    tim, dat = timedate(zdt)
    tim = tim + fast_time
    inzone = in_zone(zdt)
    atzone = at_zone(zdt)
    TimeDateZone(tim, dat, inzone, atzone)
end

function (-)(x::TimeDateZone, y::Period)
    return x + (-y)
end

(+)(y::Period, x::TimeDateZone) = x + y

function (+)(x::TimeDateZone, y::Period, idx::Int)
    fast_part, slow_part = fastslow(y)
    zdt = ZonedDateTime(x)
    zdt = ZonedDateTime(DateTime(x), in_zone(zdt), idx)
    fast_time = at_time(x) - at_time(zdt)
    fast_time += fast_part
    zdt = zdt + slow_part
    tim, dat = timedate(zdt)
    tim = tim + fast_time
    inzone = in_zone(zdt)
    atzone = at_zone(zdt)
    TimeDateZone(tim, dat, inzone, atzone)
end

function (-)(x::TimeDateZone, y::Period, idx::Int)
    return (+)(x, (-y), idx)
end

(+)(y::Period, x::TimeDateZone, idx::Int) = (+)(x, y, idx)



function (+)(x::TimeDateZone, y::CompoundPeriod)
    result = x
    for period in y
        result += period
    end
    return result
end

function (-)(x::TimeDateZone, y::CompoundPeriod)
    result = x
    for period in y
        result -= period
    end
    return result
end

(+)(y::CompoundPeriod, x::TimeDateZone) = x + y
