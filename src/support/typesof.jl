
typesof(x::CompoundPeriod) = map(typeof, x.periods)
typesof(x::P) where {P<:Period} = (P,)
typesof(x::Array{Any, N}) where {N} = map(typesof, x)
typesof(x) = eltypeof(x)
