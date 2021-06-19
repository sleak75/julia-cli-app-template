" config relevant to applying updates to the list "
module UpdatesSetup
export UpdateConfig

using Configurations
@option mutable struct UpdateConfig
    all::Bool
    replace::Bool
end
UpdateConfig() = UpdateConfig(false, false)

end 

