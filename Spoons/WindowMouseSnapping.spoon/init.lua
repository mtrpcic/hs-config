-- Load Dependencies
local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"

-- Spoon Container Object
local obj = {}
obj.__index = obj

-- Spoon Metadata
obj.name = "ConfigReloader"
obj.version = "1.0"
obj.author = "Mike Trpcic"

-- Spoon Configuration Variables
obj.draggingStatus = nil
obj.draggingWindow = nil


-- Hotkey Definition (All keys inherit hyper)
obj.hotkeys = {
    primary = {

    },

    secondary = {
        M = "stop"
    }
}

-- Internal Variables
obj.mouseEvents = {
    ['leftMouseDragged'] = "onMouseDrag",
    ['leftMouseUp'] = "onMouseUp"
}

obj.activeEvents = {}
obj.windowTitlebarHeight = 21
obj.monitorEdgeSensitivity = 5

-- Utility Methods
function round(num)
	return math.floor(num + 0.5)
end

function getActiveWindow()
    return hs.application.frontmostApplication():focusedWindow()    
end

-- Spoon Methods
function obj:isMouseAtTop(coords, frame)
    return coords.y < self.monitorEdgeSensitivity
end

function obj:isMouseAtBottom(coords, frame)
    return coords.y > frame.h - self.monitorEdgeSensitivity
end

function obj:isMouseAtLeft(coords, frame)
    return coords.x < self.monitorEdgeSensitivity
end

function obj:isMouseAtRight(coords, frame)
    return coords.x > frame.w - self.monitorEdgeSensitivity
end

function obj:onMouseDrag()
    if not self.draggingStatus then
        local win = getActiveWindow()

        if win ~= nil then
            -- Check if mouse is in titlebar
            local m = hs.mouse.getAbsolutePosition()
            local mx = round(m.x)
            local my = round(m.y)

            local f = win:frame()

            if mx > f.x and mx < (f.x + f.w) then
                if my > f.y and my < (f.y + self.windowTitlebarHeight) then
                    self.draggingWindow = win
                    self.draggingStatus = true        
                end
            end
        end
    end
end

function obj:onMouseUp()
    if self.draggingStatus then
        local m = hs.mouse.getAbsolutePosition()
        local win = getActiveWindow()
        local max = win:screen():frame()

        --if round(m.x) == 0 or round(m.x) == max.w or round(m.y) == 0 or round(m.y) == max.h then
        self:applySnap(win, m, max)
        --end

        self.draggingStatus = false
        self.draggingWindow = nil
    end
end



function obj:applySnap(win, coords, max)
    local width = max.w
    local height = max.h
    local x = 0
    local y = 0
    local flag = false

    if self:isMouseAtTop(coords, max) then
        flag = true
        if self:isMouseAtLeft(coords, max) or self:isMouseAtRight(coords, max) then
            height = height / 2
        end
    end

    if self:isMouseAtBottom(coords, max) then
        height = height / 2
        y = height
        flag = true
    end

    if self:isMouseAtLeft(coords, max) then
        width = width / 2
        flag = true
    end

    if self:isMouseAtRight(coords, max) then
        width = width / 2
        x = width
        flag = true
    end

    if flag then
        local frame = win:frame()
        frame.x = round(x)
        frame.y = round(y)
        frame.w = round(width)
        frame.h = round(height)
        win:setFrameWithWorkarounds(frame)
    end
end

function obj:start()
    -- For OSX event timing issues, we need to hook in after _some_ animation.
    if hs.window.animationDuration == 0 then
        hs.window.animationDuration = 0.00000001    
    end

    hs.window.setFrameCorrectness = true
    self:bindMouseEvents()
end

function obj:stop()
    for index, event in ipairs(self.activeEvents) do
        event:stop()
    end
    self.activeEvents = {}
end

return obj