module CheckCommand

# -------------------------------------------------------------------
using ArgParse
#function prepare_argparsing!(args::ArgParseSettings, args_to_import::ArgParseSettings...)
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
#    for a in args_to_import
#        import_settings(args["check"], a)
#    end
end

using ..Config
function update_config!(config::CompleteConfig, command_args::Dict{String,T}, 
                        common_args::Dict{String,T}) where T
    # no extra config needed for check
    @debug "updating config for CheckCommand (no-op)"
end

function run_command(config::CompleteConfig, command_args::Dict{String,T}) where T
    @info "called check with $command_args"
end
end
