module ConfigFiles
export apply_configfile

using TOML
using Configurations
using ..Settings
using ..Utils

function apply_configfile(settings::AllSettings, path::String)::AllSettings

    println("applying configfile $path")
    d1 = to_dict(settings)
    d2 = TOML.parsefile(path) #|> to_dict
    if haskey(d2, "logging") 
        d = d2["logging"]
        allowed_loglevels = join(keys(loglevels),",")
        for key in ("verbosity", "loglevel")
            !haskey(d,key) || is_valid_loglevel(d[key]) || 
                throw(DomainError("$key must be one of {$allowed_loglevels}"))
        end
    end
    d = deepmerge(d1, d2)
    println("d1 is $d1\n")
    println("d2 is $d2\n")
    println("d is $d\n")
    return from_dict(AllSettings, d)

end

function apply_configfile(path::String)::AllSettings
    s = AllSettings()
    return apply_configfile(s, path)
end
#apply_configfile(path::String) = apply_configfile(s, path)

end
