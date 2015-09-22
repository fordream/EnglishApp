
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local EADataManager = require("src/app/EATools/EADataManager")
local EASpeechSystem = require("src/app/EATools/EASpeechSystem")

function MainScene:ctor()
    local root = cc.CSLoader:createNode("MainScene.csb"):addTo(self)
    local scrollView = root:getChildByName("ScrollView")
--    local hudLayer = root:getChildByName("HudLayer")

    local playBtn = scrollView:getChildByName("PlayBtn")
    playBtn:addTouchEventListener(function(sender,evt)
        if evt == 2 then
            app:enterSceneWithTransition("EAGameScene")
--            cc.Director:getInstance():runWithScene("CAGameScene")
--            display.news
        end
    end)
    
    local btn = root:getChildByName("Button"):addTouchEventListener(function(sender,evt)
        if evt == 2 then
            luaoc.callStaticMethod("EAISpeechEvaluator","startSpeechEvaluate",{})
        end
    end)
        
    local btn2 = root:getChildByName("Button2"):addTouchEventListener(function(sender,evt)
        if evt == 2 then
            luaoc.callStaticMethod("EAISpeechEvaluator","stopSpeechEvaluate",nil)
        end
    end)
    
    local args = {
        word = "error! No words in dict"
    }
    
    local btn3 = root:getChildByName("Button3"):addTouchEventListener(function(sender,evt)
        if evt == 2 then
            luaoc.callStaticMethod("EAISpeechSynthesizer","onStartSpeech",args)
        end
    end)
    
    local tb = EADataManager.loadCsvFile("file.csv")
    dump(tb)
    
    EASpeechSystem.checkNetwork()
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
