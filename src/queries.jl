" config relevant to querying the list "
module Queries
export QueryConfig
using Configurations
@option mutable struct QueryConfig
    exact::Bool
    or::Bool
end
QueryConfig() = QueryConfig(false, false)

# -------------------------------------------------------------------
using ArgParse
function prepare_argparsing()::ArgParseSettings
    query_args = ArgParseSettings()
    @add_arg_table query_args begin
        "--exact", "-x"
            help = "search for exact matches as fixed strings (not regex)"
            action = :store_true
        "--or"
            help = "combine search terms with OR instead of AND"
            action = :store_true
        "query_terms"
            help = "whitespace-separated search terms as name=value"
            nargs = '*'
            arg_type = String
    end
    query_args
end 

function update_config!(config::QueryConfig, command_args::Dict{String,T}, 
                        common_args::Dict{String,T}) where T
    get_if(d,k) = get(d,k,false)
    config.exact |= get_if(command_args, "exact") || get_if(common_args,"exact")
    config.or |= get_if(command_args, "or") || get_if(common_args,"or")
end

function query_result(config::QueryConfig, command_args::Dict{String,T})::Integer where T 
    # FIXME needs to return something smarter
    println("querying ..")
    1 # placeholder
end

end
