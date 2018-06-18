-- Spoon Container Object
local obj = {}
obj.__index = obj

-- Spoon Metadata
obj.name = "ConfigReloader"
obj.version = "1.0"
obj.author = "Mike Trpcic"

-- Spoon Configuration Variables

-- Hotkey Definition (All keys inherit hyper)
obj.hotkeys = {
    primary = {
    },

    secondary = {
    }
}

-- Utility Methods
function getActiveWindow()
    return hs.application.frontmostApplication():focusedWindow()    
end

-- Spoon Methods
function obj:bindHotkeys(hyper)
    local hyper_types = {"primary", "secondary"}
    local def = {}
    local map = {}

    for i, type in ipairs(hyper_types) do
        for key, name in pairs(self.hotkeys[type]) do
            map[name] = { hyper[type], key}
            local dispatch = function()
                return self[name](self)
            end

            def[name] = dispatch
        end
    end

    hs.spoons.bindHotkeysToSpec(def, map)
end

function obj:start()
    hs.grid.setGrid(self.grid.columns .. "x" .. self.grid.rows)
    hs.grid.setMargins(self.grid.margins .. "x" ..self.grid.margins)
    hs.window.animationDuration = 0
end

return obj