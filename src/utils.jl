module Utils
export deepmerge

function deepmerge(d1::AbstractDict, d2::AbstractDict)
    combine(e1::AbstractDict, e2::AbstractDict) = deepmerge(e1,e2)
    combine(e1::Vector,e2::Vector) = vcat(e1,e2)
    combine(e1::Any,e2::Any) = e2
    d = copy(d1)
    for k in keys(d2)
        d[k] = haskey(d1,k) ? combine(d1[k],d2[k]) : d2[k] 
    end
    d
end

end

