local EASpeechSystem = {}

local _user = nil
function EASpeechSystem.getIsInUse()
    if _user ~= nil then
	   return true
    else
       return false
    end
end

function EASpeechSystem.addUser(obj)
    local pRet = false
    if not EASpeechSystem.getIsInUse() then
        _user = obj
        pRet = true
    else
        printLog("ERROR:","EASpeechSystem is in use")
        pRet = false
    end
    return pRet
end

function EASpeechSystem.removeUser()
    _user = nil
end

function EASpeechSystem.onSynthesizeToUri(user,wordStr)
    if user == nil or type(wordStr) ~= "string" or string.len(wordStr) == 0 then
        return false
    end

    _user = user
    local args = {
        word = wordStr
    }

    luaoc.callStaticMethod("EAISpeechSynthesizer","onSynthesizeToUri",args)
end

function EASpeechSystem.onStartSpeechOneWord(user,wordStr)
    if user == nil or type(wordStr) ~= "string" or string.len(wordStr) == 0 then
    	return false
    end
    
    _user = user
    local args = {
        word = wordStr
     }
     
    luaoc.callStaticMethod("EAISpeechSynthesizer","onStartSpeech",args)
end

--开始评测一个单词
function EASpeechSystem.startSpeechEvaluate(user,wordStr)
    if user == nil or type(wordStr) ~= "string" or string.len(wordStr) == 0 then
        return false
    end
    
    _user = user
    local args = {
        word = wordStr
     }
     
    luaoc.callStaticMethod("EAISpeechEvaluator","startSpeechEvaluate",args)
	
end

--结束品测一个单词
function EASpeechSystem.stopSpeechEvaluate(user)
    if user == nil then
        return false
    end

    _user = user
    local args = {
    }

    luaoc.callStaticMethod("EAISpeechEvaluator","stopSpeechEvaluate",args)

end

function EASpeechSystem.checkNetwork()
     if not network.isInternetConnectionAvailable() then
         device.showAlert("无网络连接","请检查网络连接","好的",nil)
    end
end

--IFlySpeechSynthesizerDelegate
--EAISpeechSynthesizer callback
function EASpeechSystem.onCompleted(error)
    _user:onSpeechCompleted()
end

function EASpeechSystem.onSpeakBegin()
    print("lua speech begin")
end

function EASpeechSystem.onSpeakCancel()
end

function EASpeechSystem.onSpeakPaused()
	
end

function EASpeechSystem.onSpeakResumed()
	
end

function EASpeechSystem.onSpeakProgress(progress)
	
end

function EASpeechSystem.onBufferProgress(progress, msg)
	
end

--IFlySpeechEvaluatorDelegate
--EAISpeechEvaluator的回调函数
function EASpeechSystem.onVolumeChanged(volume)
	
end

function EASpeechSystem.onBeginOfSpeech()

end

function EASpeechSystem.onEndOfSpeech()

end

function EASpeechSystem.onCancel()

end

function EASpeechSystem.onError(errorCode,errorDesc)

end

function EASpeechSystem.onResults(results,isLast)
end

function EASpeechSystem.onParserResult(results)
    print("score:" .. results)
    _user:onParserResult(results)
end

--使用之前，初始化，注册lua回调函数。告诉OC类，lua回调函数的ID
function EASpeechSystem.init()
    local speechArgs = {
        luaOnCompleted = EASpeechSystem.onCompleted,
        luaOnSpeakBegin = EASpeechSystem.onSpeakBegin,
        luaOnBufferProgress = EASpeechSystem.onBufferProgress,
        luaOnSpeakProgress = EASpeechSystem.onSpeakProgress,
        luaOnSpeakResumed = EASpeechSystem.onSpeakResumed,
        luaOnSpeakPaused = EASpeechSystem.onSpeakPaused,
        luaOnSpeakCancel = EASpeechSystem.onSpeakCancel,
    }
    luaoc.callStaticMethod("EAISpeechSynthesizer","registerScriptHandler",speechArgs)
    
    local args = {
        luaOnResults = EASpeechSystem.onResults,
        luaOnError = EASpeechSystem.onError,
        luaOnCancel = EASpeechSystem.onCancel,
        luaOnEndOfSpeech = EASpeechSystem.onEndOfSpeech,
        luaOnBeginOfSpeech = EASpeechSystem.onBeginOfSpeech,
        luaOnVolumeChanged = EASpeechSystem.onVolumeChanged,
        luaOnParserResult = EASpeechSystem.onParserResult,
    }
    luaoc.callStaticMethod("EAISpeechEvaluator","registerScriptHandler",args)

end

return EASpeechSystem