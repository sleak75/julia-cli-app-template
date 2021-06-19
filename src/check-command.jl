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

using ..CompleteConfig
function update_config!(config::Config, command_args::Dict{String,T}, 
                        common_args::Dict{String,T}) where T
    # no extra config needed for check
end

function run_command(config::Config, command_args::Dict{String,T}) where T
    println("called check with $command_args")
end
end
