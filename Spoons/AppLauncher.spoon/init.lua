-- Spoon Container Object
local obj = {}
obj.__index = obj

-- Spoon Metadata
obj.name = "AppLauncher"
obj.version = "1.0"
obj.author = "Mike Trpcic"

-- Spoon Configuration Variables
obj.config_path = hs.configdir

-- Hotkey Definition
-- -----------------
-- Map each hotkey directly to the Application name that should be called
obj.hotkeys = {
    primary = {
        T = "iTerm",
        C = "Google Chrome"
    },

    secondary = {

    }
}

-- Spoon Locals
obj.watcher = nil

-- Spoon Methods
function obj:bindHotkeys(hyper)
    local hyper_types = {"primary", "secondary"}
    local def = {}
    local map = {}

    for i, type in ipairs(hyper_types) do
        for key, name in pairs(self.hotkeys[type]) do
            map[name] = { hyper[type], key}
            def[name] = function()
                hs.application.launchOrFocus(name)
            end
        end
    end

    hs.spoons.bindHotkeysToSpec(def, map)
end

function obj:start()
end

return obj