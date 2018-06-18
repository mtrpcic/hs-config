-- Variables & Configuration
local hyper = {
    primary = {"cmd", "alt", "ctrl"},
    secondary = {"cmd", "alt", "ctrl", "shift"}
}

local spoons = {
    ConfigReloader = true,
    WindowManagement = true,
    AppLauncher = true,
    SpacesManagement = false,
    WindowSnapping = false
}

-- Import Configured Spoons
for spoonName, enabled in pairs(spoons) do
    if enabled then
        hs.loadSpoon(spoonName)
        spoon[spoonName].start(spoon[spoonName])
        spoon[spoonName].bindHotkeys(spoon[spoonName], hyper)
    end
end