--local EAGameScene = class("EAGameScene",function()
--    return display.newScene("EAGameScene")
--end)
local EAGame = import("src/app/models/EAGame.lua")
local EAGameScene = class("EAGameScene",EAGame)
 
function EAGameScene:ctor()
--    local root = cc.CSLoader:createNode("GameScene.csb"):addTo(self)
--    local root = cc.CSLoader:createNode("scene_1/gamescene_1.csb"):addTo(self)
    EAGameScene.super.ctor(self)

    local root = nil
    root = self:createFromCSB("scene_1/gamescene_1.csb","scene_1/gameInfo.json")
    root:addTo(self)
    self:begin()

--    self:changeState(EAGame.STATE_BEGIN)
--    
--    self.gameInfo.groups[1][1].bingo()
--    self.gameInfo.groups[1][1].highLight()
    
 --    local btn = root:getChildByName("Button_1")
--    btn:addTouchEventListener(function(sender,evt)
--        if evt == 2 then
--            app:enterSceneWithTransition("MainScene")
--            --            cc.Director:getInstance():runWithScene("CAGameScene")
--            --            display.news
--        end
--    end)
end

--function EAGameScene:begin()
--end

function EAGameScene:showStory()
    print("EAGameScene stroy")
end

function EAGameScene:beginSpeak()
end

function EAGameScene:beginEvaluate()
end

function EAGameScene:showBonus()
end

function EAGameScene:over()
end

return EAGameScene