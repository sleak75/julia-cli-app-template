module Settings
export AllSettings, loglevels, is_valid_loglevel

using Configurations

# define my own levels because I want to be able to increment and 
# decrement them acocrding to count of -v/-q options, , and also ad
loglevels = Dict("silent"=>0, "error"=>1, "warn"=>2, "info"=>3, "debug"=>4)
is_valid_loglevel = x -> haskey(loglevels,x)

@option struct LoggingSettings
    verbosity::String
    log_level::Union{String, Nothing}
    log_filename::Union{String, Nothing}
    overwrite::Bool
end
LoggingSettings() = LoggingSettings("warn",nothing,nothing,false)

@option struct QuerySettings
    exact::Bool
    or::Bool
end
QuerySettings() = QuerySettings(false, false)

@option struct UpdateSettings
    all::Bool
    replace::Bool
end
UpdateSettings() = UpdateSettings(false,false)

@option struct AllSettings
    logging::LoggingSettings
    query::QuerySettings
    update::UpdateSettings
end
AllSettings() = AllSettings(LoggingSettings(),QuerySettings(),UpdateSettings())

end
