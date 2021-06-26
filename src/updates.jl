" config relevant to applying updates to the list "
module UpdatesSetup
export UpdateConfig

using Configurations
@option mutable struct UpdateConfig
    all::Bool
    replace::Bool
end
UpdateConfig() = UpdateConfig(false, false)

# -------------------------------------------------------------------
using ArgParse
function prepare_argparsing()::ArgParseSettings
    update_args = ArgParseSettings()
    @add_arg_table update_args begin
        "--all", "-a"
            help = "if multiple records match, apply update to all "*
                   "(not raising error)"
            action = :store_true
        "--replace", "-r"
            help = "replace (not append) array and object properties"
            action = :store_true
        # double dash to indicate "everything from here is positional" doesn't 
        # seem to work in the presence of the "query_terms" argument, perhaps
        # because query_terms was already a positional argument.
        # So use an actual option to indicate the update to apply:
        "--with", "-w"
            help = "update to apply to matching record(s)"
            # since this is an option, it won't necessarily be last, so we'll 
            # expect a single (therefore, quoted) string
            nargs = 1
            arg_type = String
            # if --with is unset then we should read from stdin
    end
    update_args
end

function apply_cmdline_args!(config::UpdateConfig, command_args::Dict{String,T}, 
                             common_args::Dict{String,T}) where T
    config.all |= get(command_args, "all", false) || get(common_args,"all", false)
    config.replace |= get(command_args, "replace", false) || get(common_args,"replace", false)
end
end 

