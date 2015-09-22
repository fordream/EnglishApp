local EADataManager = {}

--读取csv文件，注意该文件一定是标准的csv格式。从第三行开始是内容，第一行是标题，第二行是注释
--[[形式如下：
ID,WORD,DES
ID,单词,描述
1,table,桌子
2,apple,苹果
3,hello,你好  
]]
function EADataManager.loadCsvFile(filePath)
    
--    if not cc.FileUtils:getInstance():isFileExist(filePath) then
--        printLog("ERROR","指定文件不存在:%s",filePath)
--        return nil
--    end
--	 -- 读取文件
--    local data = cc.FileUtils:getInstance():getStringFromFile(filePath);
--    if string.len(data) <= 0 then
--        printLog("ERROR:","读取文件为空")
--        return nil
--    end

     local data = EADataManager.loadFile(filePath)
      
    -- 按行划分
--    local lineStr = EADataManager.split(data, "\n");
    local lineStr = string.split(data, "\n");

    --[[
                从第3行开始保存（第一行是标题，第二行是注释，后面的行才是内容） 
             
                用二维数组保存：arr[ID][属性标题字符串]
    ]]
    local titles = string.split(lineStr[1], ',');
    local ID = 1;
    local arrs = {};
    dump(titles)
    for i = 3, #lineStr, 1 do
        -- 一行中，每一列的内容
        local content = string.split(lineStr[i], ',');
 
         -- 以标题作为索引，保存每一列的内容，取值的时候这样取：arrs[1].Title
        arrs[ID] = {};
        for j = 1, #titles, 1 do
            arrs[ID][titles[j]] = content[j];
        end
 
        ID = ID + 1;
    end
 
    return arrs;
end

function EADataManager.loadFile(filePath)
    if not cc.FileUtils:getInstance():isFileExist(filePath) then
        printLog("ERROR","指定文件不存在:%s",filePath)
        return nil
    end
    -- 读取文件
    local data = cc.FileUtils:getInstance():getStringFromFile(filePath);
    if string.len(data) <= 0 then
        printLog("ERROR:","读取文件为空")
        return nil
    end
    return data
end

return EADataManager