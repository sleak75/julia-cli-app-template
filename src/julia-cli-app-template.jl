# template for a CLI app
#
# The template uses a Blackboard architecture for the app configuration: a
# CompleteConfig struct 

# first gather functionality that is used by multiple commands:
include("logging.jl")
include("queries.jl")
include("updates.jl")
include("config.jl")
include("check-command.jl")
include("find-command.jl")
include("update-command.jl")

using ArgParse
using TOML

using .LoggingSetup
using .Queries
using .UpdatesSetup
using .CheckCommand
using .FindCommand
using .UpdateCommand
using .Config: CompleteConfig, apply_config

# read commandline first, in case options there set places to read configs
logging_args = LoggingSetup.prepare_argparsing()
query_args = Queries.prepare_argparsing()
#update_args = UpdateCommand.prepare_argparsing()
commands = ArgParseSettings()
@add_arg_table commands begin
    "check"
        help = "check validity of input"
        action = :command
    "find"
        help = "query the list for items meeting search terms"
        action = :command
    "update"
        help = "merge input into the list"
        action = :command
end

args = ArgParseSettings()
import_settings(args, logging_args)
import_settings(args, commands)

args["check"] = CheckCommand.prepare_argparsing()
import_settings(args["check"], logging_args)
args["find"] = FindCommand.prepare_argparsing()
import_settings(args["find"], logging_args)
import_settings(args["find"], query_args)
args["update"] = UpdateCommand.prepare_argparsing()
import_settings(args["update"], logging_args)
import_settings(args["update"], query_args)

command_module = Dict(
    "check" => CheckCommand,
    "find" => FindCommand,
    "update" => UpdateCommand
    )

parsed_cmdline = parse_args(args)
cmd = parsed_cmdline["%COMMAND%"]
# args might land in the common area, or under the command, so each 
# command or config section will need to merge them appropriately
parsed_common_args = parsed_cmdline
parsed_command_args = parsed_cmdline[cmd]

# apply defaults first, may get overridden by later configs
config = CompleteConfig()
root = dirname(dirname(@__FILE__))
path = joinpath(root, "etc", "defaults.toml") |> normpath
config = apply_config(config, TOML.parsefile(path)) 

# could apply other config files, or config from env vars
#config = apply_config(config, TOML.parsefile(another_path)) 

# setup cross-cutting stuff like logging, paths:
LoggingSetup.update_config!(config.logging, parsed_cmdline[cmd], parsed_cmdline)
LoggingSetup.setup_logging(config.logging)
# setup_paths!(config.paths, parsed_command_args, parsed_common_args)


command_module[cmd].update_config!(config, parsed_cmdline[cmd], parsed_cmdline)
command_module[cmd].run_command(config, parsed_cmdline[cmd])



