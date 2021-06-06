module ArgParsing
export apply_commandline_args

using ArgParse
using ..Settings
using ..Utils

function apply_commandline_args(settings::AllSettings, args_list::Vector)::AllSettings

    println("applying args")
    logging_args = ArgParseSettings()
    @add_arg_table logging_args begin
        "--verbose", "-v"
            help = "increase console verbosity"
            action = :count_invocations
        "--quiet", "-q"
            help = "decrease console verbosity"
            action = :count_invocations
        "--log-append"
            help = "append log messages to <filename>"
            action = :store_arg
            arg_type = String
            metavar = "FILE"
        "--log-overwrite"
            help = "log messages to <filename>, overwriting if it exists"
            action = :store_arg
            arg_type = String
            metavar = "FILE"
        "--log-level"
            help = "set level for logging to file, distinct from console "*
                   "verbosity. One of {$(join(keys(loglevels),","))}"
            nargs = 1
            arg_type = String
            range_tester = is_valid_loglevel
            metavar = "LEVEL"
    end

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

    args = ArgParseSettings()
    @add_arg_table args begin
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

    import_settings(args, logging_args)

    import_settings(args["find"], logging_args)
    import_settings(args["find"], query_args)
    # find is a subset of update, so no extra specific args to add here

    import_settings(args["update"], logging_args)
    import_settings(args["update"], query_args)
    @add_arg_table args["update"] begin
        "--all", "-a"
            help = "if multiple records match, apply update to all "*
                   "(not raising error)"
            action = :store_true
        "--replace", "-r"
            help = "replace (not append) array and object properties"
            action = :store_true
        # double dash to indicate "everything from here is positional" doesn't 
        # seem to work in the presence of the "query_terms" argument (maybe a 
        # bug?). So use an actual option to mark the final argument
        "--with", "-w"
            help = "update to apply to matching record(s)"
            # since this is an option, it won't necessarily be last, so we'll 
            # expect a single (therefore, quoted) string
            nargs = 1
            arg_type = String
            # if --with is unset then we should read from stdin
    end

    import_settings(args["check"], logging_args)
    @add_arg_table args["check"] begin
        "filename"
            help = "path(s) to file(s) to check (default is stdin)"
            nargs = '*'
            arg_type = String
            # if there are none it should read from stdin
    end

    cmdline = parse_args(args_list, args)
    println(cmdline)
    s1 = to_dict(settings)
    d = deepmerge(s1, cmdline)
    println(d)
    return from_dict(AllSettings, d)

end

apply_commandline_args(args_list::Vector) = apply_commandline_args(AllSettings(), args_list)
apply_commandline_args(settings::AllSettings) = apply_commandline_args(settings, ARGS)
apply_commandline_args() = apply_commandline_args(AllSettings(), ARGS)

end
