" implements 'myapp update <args>' "
module UpdateCommand

using ArgParse
" update command argparsing is only query + update argparsing "
prepare_argparsing() = ArgParseSettings()

using ..Config
using ..Queries
using ..UpdatesSetup

function apply_cmdline_args!(config::CompleteConfig, command_args::Dict{String,T}, 
                        common_args::Dict{String,T}) where T
    Queries.apply_cmdline_args!(config.query, command_args, common_args)
    UpdatesSetup.apply_cmdline_args!(config.update, command_args, common_args)
end

""" 
Run this command. config holds the behavior settings accumulated from the command
line, any config files and any environment variables; and command_args holds the 
command line in dict form (including, most importantly, the positional args)
"""
function run_command(config::CompleteConfig, command_args::Dict{String,T}) where T
    @info "called update with $command_args"
    target = Queries.query_result(config.query, command_args)
    # now apply the update to each thing in the target
end

end 

