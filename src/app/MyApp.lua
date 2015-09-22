
require("config")
require("cocos.init")
require("framework.init")
require("src.app.EATools.Const")
require("src.app.EATools.EAUtility")

local MyApp = class("MyApp", cc.mvc.AppBase)
local EASpeechSystem = require("src/app/EATools/EASpeechSystem")

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    EASpeechSystem.init()
    self:enterScene("MainScene")
end

return MyApp
