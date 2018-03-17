
typesof(x::Array{Any, N}) where {N} = map(typesof, x)
typesof(x) = eltypeof(x)
