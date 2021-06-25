module LoggingSetup 
export LoggingConfig

# -------------------------------------------------------------------
" define own enum for log levels, to add 'silent' (disable-logging) level"
@enum ValidLogLevel silent error warn info debug

import Logging # import because we'll define a new LogLevel constructor
function Base.convert(::Type{Logging.LogLevel},level::ValidLogLevel)
    map = Dict(error=>Logging.Error, warn=>Logging.Warn, 
               info=>Logging.Info, debug=>Logging.Debug)
    map[level]
end
Logging.LogLevel(level::ValidLogLevel) = convert(Logging.LogLevel, level)

function Base.convert(::Type{ValidLogLevel},s::String)
    map = Dict("silent"=>silent, "error"=>error, "warn"=>warn, 
               "info"=>info, "debug"=>debug)
    map[s]
end

function Base.:+(a::ValidLogLevel,b::Integer)::ValidLogLevel
    ValidLogLevel(min(Integer(a)+b,Integer(debug)))
end
function Base.:-(a::ValidLogLevel,b::Integer)::ValidLogLevel
    ValidLogLevel(max(Integer(a)-b,Integer(silent)))
end

# -------------------------------------------------------------------
using Configurations

"LoggingConfig holds the logging-related configuration the app will use"
@option mutable struct LoggingConfig
    verbosity::ValidLogLevel
    log_level::Union{ValidLogLevel, Nothing}
    log_path::Union{String, Nothing}
    overwrite::Bool
end
LoggingConfig() = LoggingConfig(warn, nothing, nothing, false)

# -------------------------------------------------------------------
using ArgParse

function prepare_argparsing()::ArgParseSettings
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
            arg_type = String
            metavar = "FILE"
        "--log-level"
            help = "set level for logging to file, distinct from console "*
                   "verbosity. One of {$(join(instances(ValidLogLevel),","))}"
            nargs = 'A'
            arg_type = ValidLogLevel
            metavar = "LEVEL"
    end
    logging_args
end

# -------------------------------------------------------------------
""" maybe() is like something(), but returns nothing in the event
    that all arguments are nothing (instead of raising Error)
"""
function maybe(v::Vector)
    things = filter(x->x!==nothing, v)
    size(things)[1]==0 ? nothing : first(something(things))
end    
maybe(v...) = maybe([v...])

function update_config!(config::LoggingConfig, command_args::Dict{String,T}, 
                        common_args::Dict{String,T}) where T
    config.verbosity += command_args["verbose"] + common_args["verbose"] -
                        command_args["quiet"] - common_args["quiet"]
    config.log_level = maybe(command_args["log-level"],
                                       common_args["log-level"],
                                       config.log_level,
                                       config.verbosity) 
    append_path = maybe(command_args["log-append"], common_args["log-append"])
    overwrite_path = maybe(command_args["log-overwrite"], common_args["log-overwrite"])
    if overwrite_path!==nothing
        if append_path!==nothing 
            throw(ArgumentError("--log-append and --log-overwrite are mutually-exclusive"))
        else
            config.overwrite = true
        end
    end
    config.log_path = maybe(append_path, overwrite_path, config.log_path)
end

using Logging
using LoggingExtras
function setup_logging(config::LoggingConfig)  
    loggers = Vector()
    MaybeLogger(x,lvl) = lvl == silent ? NullLogger() : MinLevelLogger(x,Logging.LogLevel(lvl))
    ConsoleLogger(stderr, config.verbosity) |> 
        x -> MaybeLogger(x,config.verbosity) |>
        x-> push!(loggers, x)
    if config.log_path !== nothing
        log_level = something(config.log_level, config.verbosity)
        FileLogger(config.log_path; append=!config.overwrite) |>
            x -> MaybeLogger(x, log_level) |>
            x -> push!(loggers,x)
    end
    TeeLogger(loggers...) |> global_logger
end 

end
