-- Variables & Configuration
local hyper = {
    primary = {"cmd", "alt", "ctrl"},
    secondary = {"cmd", "alt", "ctrl", "shift"}
}

-- unused currently
local config = {
    DisableWindowAnimations = true
}

local spoons = {
    ConfigReloader = true,
    WindowGridSnapping = true,
    --WindowMouseSnapping = true,
    AppLauncher = true,
    SpacesManagement = false
}

-- Import Configured Spoons
for spoonName, enabled in pairs(spoons) do
    if enabled then
        hs.loadSpoon(spoonName)
        spoon[spoonName].start(spoon[spoonName])
        spoon[spoonName].bindHotkeys(spoon[spoonName], hyper)
    end
end