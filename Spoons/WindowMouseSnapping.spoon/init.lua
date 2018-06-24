-- Load Dependencies
local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"
local Point     = require "Util/Point"
local Math     = require "Util/Math"

-- Spoon Container Object
local obj = BaseSpoon.new()

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

-- Mouse Event Mapping
obj.mouseEvents = {
    ['leftMouseDragged'] = "onMouseDrag",
    ['leftMouseUp'] = "onMouseUp"
}

-- Internal variables
obj.activeEvents = {}
obj.windowTitlebarHeight = 21
obj.monitorEdgeSensitivity = 5

-- Method to be called when a mouse drag event
function obj:onMouseDrag()
    if not self.draggingStatus then
        local win = Window.getActiveWindow()

        if win ~= nil then
            -- Check if mouse is in titlebar
            local m = hs.mouse.getAbsolutePosition()
            local mx = Math.round(m.x)
            local my = Math.round(m.y)

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

-- Method to be called when the mouse "click" is released. This method is a no-op
-- unless we previously recorded that the mouse was dragging.
function obj:onMouseUp()
    if self.draggingStatus then
        local m = hs.mouse.getAbsolutePosition()
        local win = Window.getActiveWindow()
        local max = win:screen():frame()

        if Math.round(m.x) == 0 or Math.round(m.x) == max.w or Math.round(m.y) == 0 or Math.round(m.y) == max.h then
            self:applySnap(win, m, max)
        end

        self.draggingStatus = false
        self.draggingWindow = nil
    end
end

-- Apply the snap to the window. This method will calculate the appropriate height, width, and coordinates
-- of window origin and apply them to the window.
function obj:applySnap(win, coords, max)
    local width = max.w
    local height = max.h
    local x = 0
    local y = 0
    local flag = false

    if Point.isAtTop(coords, max, self.monitorEdgeSensitivity) then
        flag = true
        if Point.isAtLeft(coords, max, self.monitorEdgeSensitivity) or Point.isAtRight(coords, max, self.monitorEdgeSensitivity) then
            height = height / 2
        end
    end

    if Point.isAtBottom(coords, max, self.monitorEdgeSensitivity) then
        height = height / 2
        y = height
        flag = true
    end

    if Point.isAtLeft(coords, max, self.monitorEdgeSensitivity) then
        width = width / 2
        flag = true
    end

    if Point.isAtRight(coords, max, self.monitorEdgeSensitivity) then
        width = width / 2
        x = width
        flag = true
    end

    if flag then
        local frame = win:frame()
        frame.x = Math.round(x)
        frame.y = Math.round(y)
        frame.w = Math.round(width)
        frame.h = Math.round(height)
        win:setFrameWithWorkarounds(frame)
        Window.ensureOnScreen(win)
    end
end

function obj:start()
    -- For OSX event timing issues, we need to hook in after _some_ animation.
    if hs.window.animationDuration == 0 then
        hs.window.animationDuration = 0.00000001    
    end

    hs.window.setFrameCorrectness = true
end

function obj:stop()
    for index, event in ipairs(self.activeEvents) do
        event:stop()
    end
    self.activeEvents = {}
end

return obj