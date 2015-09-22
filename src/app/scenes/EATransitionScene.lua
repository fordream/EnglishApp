--过渡场景，避免内存中同时存在两个场景，内存占用过大
local EATransitionScene = class("EATransitionScene",function()
    return display.newScene("EATransitionScene")
end)

local scheduler = require("framework.scheduler")

function EATransitionScene:ctor()
    self.root = cc.CSLoader:createNode("TransitionScene.csb"):addTo(self)
    display.newSprite("HelloWorld.png",display.cx,display.cy):addTo(self.root)
end

function EATransitionScene:startWithNext(nextScene)
    print("scenename:" .. nextScene)
    scheduler.performWithDelayGlobal(function()
        app:enterScene(nextScene)
    end,CA_TRANSITION_DELAY_TIME)

end

return EATransitionScene