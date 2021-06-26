" config and functionality relevant to querying the list "
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

function apply_cmdline_args!(config::QueryConfig, command_args::Dict{String,T}, 
                                common_args::Dict{String,T}) where T
    config.exact |= get(command_args, "exact", false) || get(common_args,"exact", false)
    config.or |= get(command_args, "or", false) || get(common_args,"or", false)
end

function query_result(config::QueryConfig, command_args::Dict{String,T})::Integer where T 
    # FIXME change return type of this function and implement functionality here
    @info "querying .."
    1 # placeholder
end

end
