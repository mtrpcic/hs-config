-- Window Utils
-- ------------
-- This module provides utility methods that are meant to be used in conjuction with the hs.window
-- module. Methods in this module can be used by multiple window related spoons without code
-- duplication.

local Window = {}

Window.isAtMap = {
    top    = function(winFrame, screenFrame, margin) return (winFrame.y - screenFrame.y <= margin) end,
    bottom = function(winFrame, screenFrame, margin) return ((winFrame.y + winFrame.h) >= screenFrame.h - margin) end,
    left   = function(winFrame, screenFrame, margin) return (winFrame.x - screenFrame.x - margin <= 0) end,
    right  = function(winFrame, screenFrame, margin) return ((winFrame.x - screenFrame.x + winFrame.w) >= screenFrame.w - margin) end
}

function Window.getActiveWindow()
    return hs.application.frontmostApplication():focusedWindow()
end

function Window.maximize(win)
    hs.window.maximize(win)
end

function Window.isAt(win, margin, spot)
    return Window.isAtMap[spot](win:frame(), win:screen():frame(), margin)
end

function Window.isAtTop(win, withinMargin)
    return Window.isAt(win, withinMargin, "top")
end

function Window.isAtBottom(win, withinMargin)
    return Window.isAt(win, withinMargin, "bottom")
end

function Window.isAtLeft(win, withinMargin)
    return Window.isAt(win, withinMargin, "left")
end

function Window.isAtRight(win, withinMargin)
    return Window.isAt(win, withinMargin, "right")
end


return Window