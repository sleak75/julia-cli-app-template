include("utils.jl")
include("settings.jl")
include("argparsing.jl")
include("configfiles.jl")

using Logging 

using .ArgParsing
using .ConfigFiles

@warn "got args $(ARGS)" 

using .Settings
s = AllSettings()

root = dirname(dirname(@__FILE__))
settings = apply_configfile(normpath(joinpath(root, "etc", "defaults.toml")))
settings = apply_commandline_args(settings)

println(settings)
#println()
#cmd = parsed_args["%COMMAND%"]
#println(parsed_args[cmd])


