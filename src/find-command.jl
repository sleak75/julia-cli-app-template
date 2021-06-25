module FindCommand

using ArgParse
#function prepare_argparsing!(args::ArgParseSettings, 
#                             args_to_import::ArgParseSettings...)
function prepare_argparsing()::ArgParseSettings
    # find only uses query args, so no extras to set up
    args = ArgParseSettings()
#    for a in args_to_import
#        import_settings(args["find"], a)
#    end
end

using ..Queries
using ..Config

function update_config!(config::CompleteConfig, command_args::Dict{String,T}, 
                        common_args::Dict{String,T}) where T
    @info config
    @info command_args
    @info common_args
    Queries.update_config!(config.query, command_args, common_args)
end

function run_command(config::CompleteConfig, command_args::Dict{String,T}) where T
    # next run the command
    println("called find with $command_args")
    result = Queries.query_result(config.query, command_args)
end

end

