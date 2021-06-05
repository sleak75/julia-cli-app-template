#module swlist
#
#export greet
#
#greet() = println("Hello World!")
#
#end # module
#
#using .swlist
#greet()

using ArgParse

function parse_commandline()

    logging_args = ArgParseSettings()
    #add_arg_group(base_args, "Logging options", "logging")
    @add_arg_table logging_args begin
        "--verbose", "-v"
            help = "increase console verbosity"
            action = :count_invocations
        "--quiet", "-q"
            help = "decrease console verbosity"
            action = :count_invocations
    end

    query_args = ArgParseSettings()
    @add_arg_table query_args begin
        "--exact", "-x"
            help = "search for exact matches of terms as fixed strings (not regex)"
            action = :store_true
        "--or"
            help = "combine search terms with OR instead of AND"
            action = :store_true
        "query_terms"
            help = "search terms as a whitespace-separated list of name=value"
            nargs = '*'
    end

    args = ArgParseSettings()
    @add_arg_table args begin
        "check"
            help = "check validity of input"
            action = :command
        "find"
            help = "query the list for items satisfying search terms"
            action = :command
        "update"
            help = "merge input into the list"
            action = :command
    end

    import_settings(args, logging_args)

    import_settings(args["find"], logging_args)
    import_settings(args["find"], query_args)
    @add_arg_table args["find"] begin
        "--dummy", "-d"
            help = "some dummy arg specific to find"
    end

    import_settings(args["update"], logging_args)
    import_settings(args["update"], query_args)
    @add_arg_table args["update"] begin
        "--all", "-a"
            help = "if multiple records match, apply update to all (not raise error)"
            action = :store_true
        "--replace", "-r"
            help = "replace (not append) array and object properties"
            action = :store_true
        "--"
            help = "apply remaining arguments as update to record(s) found by query"
            action = :store_const
            constant = 1
            default = 0
        "json_string"
            help = "update to apply to matching record(s)
    end

    return parse_args(args)
end

parsed_args = parse_commandline()
println(parsed_args)
println(parsed_args["%COMMAND%"])
println(parsed_args["find"])


