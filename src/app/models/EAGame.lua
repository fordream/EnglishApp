--游戏逻辑的抽象
local EAGame = class("EAGame",function()
    return display.newScene("EAGame")
end)

EAGame.STATE_BEGIN = "begin"
EAGame.STATE_SHOW = "show"
EAGame.STATE_EVALUATE = "evaluate"

EAGame.STATE_STORY = "story"
EAGame.STATE_SPEAK = "speak"
EAGame.STATE_BONUS = "bonus"
EAGame.STATE_OVER = "over"

EAGame.HightLight_Act = transition.sequence({cc.ScaleTo:create(0.7,1.1),cc.ScaleTo:create(0.7,1)})

local json = require("src/framework/json")
local EADataManager = require("src/app/EATools/EADataManager")
local speech_ = require("src/app/EATools/EASpeechSystem")
local scheduler = require("framework.scheduler")


function EAGame:ctor()
    print("ctor")
 	self:init()
end

function EAGame:init()
--    记录当前游戏状态
--    当前组，和当前单词 
    self.curGroupInfo = {
        curGroupIndex = 1,
        curItemIndex = 0,
        curEvlIndex = 0,
    }
    
    self.gameInfo = nil
    
    self.state = EAGame.STATE_BEGIN
--    self:begin()
end

function EAGame:onEnter()
    speech_.addUser(self)
 end

function EAGame:onExit()
 	speech_.removeUser()
end

function EAGame:onSpeechCompleted()

    if self.state == EAGame.STATE_SHOW then
    	
        if self.curGroupInfo.curItemIndex < #self:getCurGroup() then
            self.curGroupInfo.curItemIndex = self.curGroupInfo.curItemIndex + 1
        else
            self.state = EAGame.STATE_EVALUATE
            scheduler.performWithDelayGlobal(function()    
                speech_.onStartSpeechOneWord(self,"Read this, Teddy?")
            end
            ,2)

            return
--            if self.curGroupInfo.curGroupIndex < #self.gameInfo.groups then
--            	self.curGroupInfo.curGroupIndex = self.curGroupInfo.curGroupIndex +1
--            	self.curGroupInfo.curItemIndex = 1
--            else
--    --            over
--                  return
--            end
        end
        
        scheduler.performWithDelayGlobal(function()
            self:showOneItem(self:getCurItem())
            end
        ,2)
        
    elseif self.state == EAGame.STATE_EVALUATE then
        if self.curGroupInfo.curEvlIndex < #self:getCurGroup() then
            self.curGroupInfo.curEvlIndex = self.curGroupInfo.curEvlIndex + 1
        else
            return
        end
        
        scheduler.performWithDelayGlobal(function()
            self:evaluateOneItem(self:getCurEvlItem())
        end
        ,1)
    end
    
end

function EAGame:onParserResult(results)
    print("results:" .. results)

    if results > 3.0 then
        print("greate")
--        scheduler.performWithDelayGlobal(function()
--            speech_.onStartSpeechOneWord(self,"You are right!")
--        end
--        ,2)
    else
--        scheduler.performWithDelayGlobal(function()
--            speech_.onStartSpeechOneWord(self,self:getCurEvlItem().en)
--        end
--        ,2)
        print("wrong")

    end

    if self.curGroupInfo.curEvlIndex < #self:getCurGroup() then
        self.curGroupInfo.curEvlIndex = self.curGroupInfo.curEvlIndex + 1
    else
        return
    end

    scheduler.performWithDelayGlobal(function()
        self:evaluateOneItem(self:getCurEvlItem())
    end
    ,2)
end

--游戏几个关键步骤，以下函数需要在子类中实现
function EAGame:begin()
    self.state = EAGame.STATE_SHOW
    scheduler.performWithDelayGlobal(function()
        self:RoundBegin()
    end,2)
end

function EAGame:RoundBegin()
    print("roundbegin")
    speech_.onStartSpeechOneWord(self,"What's this, Teddy?")
end

function EAGame:RoundShow()
	
end

function EAGame:RoundTest()
	
end

function EAGame:showStory()
end

function EAGame:beginSpeak()
end

function EAGame:beginEvaluate()
end

function EAGame:showBonus()
end

function EAGame:over()
end

function EAGame:changeState(state)
    if self.state_ == state then
        assert(self.state_ ~= state,"游戏状态没有改变，错误的调用")
    	return
    end
    
    self.state_ = state
    if state == EAGame.STATE_BEGIN then
	   self:begin()
    elseif state == EAGame.STATE_STORY then
       self:showStory()
    elseif state == EAGame.STATE_SPEAK then
       self:beginSpeak()
    elseif state == EAGame.STATE_EVALUATE then
       self:beginEvaluate()
    elseif state == EAGame.STATE_BONUS then
       self:showBonus()
    elseif state == EAGame.STATE_OVER then
	   self:over()
	end
	
end

--function EAGame:showOneGroup(group)
--    for key, item in group do
--    	
--    end
--end

function EAGame:showOneItem(item)
	item.highLight()
    speech_.onStartSpeechOneWord(self,item.en)
end

function EAGame:evaluateOneItem(item)
print("evl:" .. item.en)
    speech_.startSpeechEvaluate(self,item.en)
end

function EAGame:getGameInfo()
    
    return self.gameInfo
end

function EAGame:getGroupByIndex(index)
	if index < 1 or index > #self.gameInfo.groups then
	    printLog("ERROR:","获取group时，index错误:%d",index)
		return nil
	end
	
	return self.gameInfo.groups[index]
end

function EAGame:getCurGroup()
print("gourps:" .. #self.gameInfo.groups)
    return self.gameInfo.groups[self.curGroupInfo.curGroupIndex]
end

function EAGame:getCurItem()
    return self:getCurGroup()[self.curGroupInfo.curItemIndex]
end

function EAGame:getCurEvlItem()
    print("index:" .. self.curGroupInfo.curEvlIndex)
    return self:getCurGroup()[self.curGroupInfo.curEvlIndex]
end

function EAGame:getItemByIndex(groupIndex,itemIndex)
	local group = self:getGroupByIndex(groupIndex)
	if group == nil or itemIndex > #group then
        printLog("ERROR:","获取item时，index错误:%d",itemIndex)
		return nil
	end
	
	return group[itemIndex]
end

function EAGame:createFromCSB(csbname, infoname)
    local root = cc.CSLoader:createNode(csbname)
    self.gameInfo = EAGame:loadGameInfo(infoname,root)
    print("create:" .. #self.gameInfo.groups)
    return root
end

function EAGame:loadGameInfo(filename,rootnode)
    local str = EADataManager.loadFile(filename)
    
    local ret = nil
    if str and rootnode then
        ret = json.decode(str)
        for i, group in ipairs(ret.groups) do
        	for j, item in ipairs(group) do
        	   local name = item.en
                item.sprite = EAUtility.CSB_NODE(rootnode,name)

               item.highLight = function()
                    local seq = transition.sequence({cc.ScaleTo:create(0.7,1.1),cc.ScaleTo:create(0.7,1)})
                    item.sprite:runAction(seq)
               end
               
               item.bingo = function()
--               todo
               	    print("bingo")
               end
               
        	end
        end
    else
        printLog("ERROR:","加载游戏信息失败:%s",filename)
    end

    return ret

end

return EAGame