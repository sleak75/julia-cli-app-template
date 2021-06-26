module CheckCommand

# -------------------------------------------------------------------
using ArgParse
function prepare_argparsing()::ArgParseSettings
    check_args = ArgParseSettings()
    @add_arg_table check_args begin
        "filename"
            help = "path(s) to file(s) to check (default is stdin)"
            nargs = '*'
            arg_type = String
            # if there are none it should read from stdin
    end
    check_args
end

using ..Config
function apply_cmdline_args!(config::CompleteConfig, command_args::Dict{String,T}, 
                             common_args::Dict{String,T}) where T
    # no extra config needed for this command
    @debug "updating config for CheckCommand (no-op)"
end

""" 
Run this command. config holds the behavior settings accumulated from the command
line, any config files and any environment variables; and command_args holds the 
command line in dict form (including, most importantly, the positional args)
"""
function run_command(config::CompleteConfig, command_args::Dict{String,T}) where T
    @info "called check with $command_args"
end
end
