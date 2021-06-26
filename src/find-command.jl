" implements 'myapp find <args>' "
module FindCommand

using ArgParse
" find command argparsing is only query argparsing "
prepare_argparsing() = ArgParseSettings()

using ..Queries
using ..Config

function apply_cmdline_args!(config::CompleteConfig, command_args::Dict{String,T}, 
                        common_args::Dict{String,T}) where T
    @info config
    @info command_args
    @info common_args
    Queries.apply_cmdline_args!(config.query, command_args, common_args)
end

""" 
Run this command. config holds the behavior settings accumulated from the command
line, any config files and any environment variables; and command_args holds the 
command line in dict form (including, most importantly, the positional args)
"""
function run_command(config::CompleteConfig, command_args::Dict{String,T}) where T
    @info "called find with $command_args"
    result = Queries.query_result(config.query, command_args)
    #FIXME add command implementation here
end

end

