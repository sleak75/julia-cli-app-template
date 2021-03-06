module Config
export CompleteConfig, apply_config
using ..LoggingSetup
using ..Queries
using ..UpdatesSetup

using Configurations
@option mutable struct CompleteConfig
    logging::LoggingConfig
    query::QueryConfig
    update::UpdateConfig
end
CompleteConfig() = CompleteConfig(LoggingConfig(),QueryConfig(),UpdateConfig())

"merge nested json-like dicts, appending rather than replacing collections"
function deep_merge(d1::AbstractDict, d2::AbstractDict)::Dict
    combine(e1::AbstractDict, e2::AbstractDict) = deep_merge(e1,e2)
    combine(e1::Vector,e2::Vector) = vcat(e1,e2)
    combine(e1::Any,e2::Any) = e2
    d = copy(d1)
    for k in keys(d2)
        d[k] = haskey(d1,k) ? combine(d1[k],d2[k]) : d2[k]
    end
    d
end

function apply_config(settings::CompleteConfig, d::AbstractDict)::CompleteConfig
    deep_merge(to_dict(settings), d) |> x -> from_dict(CompleteConfig,x)
end
apply_config(d::AbstractDict) = apply_config(CompleteConfig(),d)

end 



