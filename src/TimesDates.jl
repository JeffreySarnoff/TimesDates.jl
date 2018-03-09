module TimeDate

export TimeDate, ZonedTimeDate

import TimeZones: ZonedDateTime

include("TimeDate.jl")
include("ZonedTimeDate.jl")

include("transitive_conversion.jl")
include("ringoid_promotion.jl")

end  # DatingTime
