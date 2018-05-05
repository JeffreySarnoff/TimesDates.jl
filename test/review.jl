function TimeDate(y::Int64, m::Int64=1, d::Int64=1,
                  h::Int64=0, mi::Int64=0, s::Int64=0, ms::Int64=0,
                  us::Int64=0, ns::Int64=0)
  uns, ns = fldmod(ns, NANOSECONDS_PER_MICROSECOND)
  us += uns
  ums, us = fldmod(us, MICROSECONDS_PER_MILLISECOND)
  ms += ums
  sms, ms = fldmod(ms, MILLISECONDS_PER_SECOND)
  s += sms
  umi, s = fldmod(s, SECONDS_PER_MINUTE)
  mi += umi
  uh, mi = fldmod(mi, MINUTES_PER_HOUR)
  h += uh
  ud, h = fldmod(h, HOURS_PER_DAY)
  d += ud
  my, m = fldmod(m, MONTHS_PER_YEAR)
  y += my
    
  dt = Date(y, m, d)
  tm = Time(h, mi, s, ms, us, ns)
  td = TimeDate(dt, tm) 
  return td
end
