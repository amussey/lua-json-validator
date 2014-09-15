function string:split(inSplitPattern, outResults)
   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

function string:trim()
    return string.match(self, "^()%s*$") and "" or string.match(self, "^%s*(.*%S)")
end



function validJson2(jsonString)
    jsonString = jsonString:trim()
    if jsonString == "{}" or jsonString == "[]" then
        return true
    end

    jsonString = string.gsub(jsonString, "\\\"", "")

    if string.sub(jsonString, 1, 1) == "{" and string.sub(jsonString, string.len(jsonString), string.len(jsonString)) == "}" then
        return validJsonArray(jsonString)
    elseif string.sub(jsonString, 1, 1) == "[" and string.sub(jsonString, string.len(jsonString), string.len(jsonString)) == "]" then
        return validJsonList(jsonString)
    end


    return false
end


function findDeepestSet(contents)
    contents = contents:trim()

    local js = 1
    local je = 2

    if string.sub(jsonString, 1, 1) == "{" then
        while string.sub(jsonString, je, je) ~= "}" do
            if string.sub(jsonString, je, je) ~= "]" then
                return false
            end
            je = je + 1
        end

        if string.sub(jsonString, je, je) ~= "}" then
            return false
        end
    end

    if string.sub(jsonString, 1, 1) == "[" then
        while string.sub(jsonString, je, je) ~= "]" do
            if string.sub(jsonString, je, je) ~= "}" then
                return false
            end
            je = je + 1
        end

        if string.sub(jsonString, je, je) ~= "]" then
            return false
        end
    end
end


function validJson(contents)
    contents = contents:trim()
    if string.sub(contents, 1, 1) ~= "{" and string.sub(contents, 1, 1) ~= "[" then
        return false
    end
    return isValid(contents)
end

function isValid(contents)
    
    contents = contents:trim()

    if contents == "{}" or contents == "[]" or contents == "\"\"" then
        return true
    end

    local js = 1
    local je = 2

    -- print("what:" .. contents)

    local searchChar = ""
    local failChar = ""

    -- print ("first char: " .. string.sub(contents, js, js))

    if string.sub(contents, js, js) == "{" then
        searchChar = "}"
        failChar = "]"
    elseif string.sub(contents, js, js) == "[" then
        searchChar = "]"
        failChar = "}"
    else
        return false
    end

    -- print ("now reading")

    while string.sub(contents, je, je) ~= searchChar and string.sub(contents, je, je) ~= "" do
        -- print(string.sub(contents, je, je) .. " looking for " .. searchChar)

        if string.sub(contents, je, je) == failChar then
            return false
        elseif string.sub(contents, je, je) == "{" then
            searchChar = "}"
            failChar = "]"
            js = je
        elseif string.sub(contents, je, je) == "[" then
            searchChar = "]"
            failChar = "}"
            js = je
        end

        -- print(tostring(string.sub(contents, je, je) == searchChar))

        je = je + 1
    end

    if string.sub(contents, je, je) == searchChar then
        -- the current array or list is from js to je


        -- if it's a list, validate it and remove it.
        arrayCheckBool = arrayCheck(string.sub(contents, js, je))
        listCheckBool = listCheck(string.sub(contents, js, je))

        -- print(tostring(arrayCheckBool) .. " and " .. tostring(listCheckBool))

        checkBool = arrayCheckBool or listCheckBool
        if checkBool then
            -- contents without the current value.
            -- print("before: " .. contents)
            contents = string.sub(contents, 1, js-1) .. "\"\"" .. string.sub(contents, je+1, string.len(contents))
            -- print("after:  " .. contents)
            return isValid(contents)
        else
            return false
        end
    end

end





























function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


function arrayCheck(contents)
    contents = contents:trim()
    contents = string.sub(contents, 2, string.len(contents)-1)

    if contents == "" then
        return true
    end

    contents = contents:split(",")

    local finalValue = true
    for _,value in pairs(contents) do
        -- print("Whoooo  " .. tostring(value))
        finalValue = finalValue and arrayitemcheck(value)
    end

    return finalValue
end

function arrayitemcheck(contents)
    contents = contents:split(":")

    if tablelength(contents) ~= 2 then
        -- There is not a key-value pair.
        return false
    end
    contents[1] = contents[1]:trim()
    contents[2] = contents[2]:trim()

    local contentValue1 = stringcheck(contents[1])

    local value = contents[2]

    local listcheckbool = false
    local arraycheckbool = false
    if string.sub(value, 1, 1) == "{" and string.sub(value, string.len(value), string.len(value)) == "}" then
        arraycheckbool = arrayCheck(string.sub(value, 2, string.len(value)-1))
    elseif string.sub(value, 1, 1) == "[" and string.sub(value, string.len(value), string.len(value)) == "]" then
        listcheckbool = listCheck(string.sub(value, 2, string.len(value)-1))
    end
    local contentValue2 = (stringcheck(value) or numbercheck(value) or listcheckbool or arraycheckbool)

    return contentValue1 and contentValue2
end




function listCheck(contents)
    contents = contents:trim()
    -- print(contents)
    if contents == "" then
        return true
    end

    -- before we split it at the comma, it might be made of multiple lists.


    contents = contents:split(",")

    local finalValue = true
    for _,value in pairs(contents) do
        local listcheckbool = false
        local arraycheckbool = false
        if string.sub(value, 1, 1) == "{" and string.sub(value, string.len(value), string.len(value)) == "}" then
            arraycheckbool = arrayCheck(string.sub(value, 2, string.len(value)-1))
        elseif string.sub(value, 1, 1) == "[" and string.sub(value, string.len(value), string.len(value)) == "]" then
            listcheckbool = listCheck(string.sub(value, 2, string.len(value)-1))
        end

        finalValue = finalValue and (stringcheck(value) or numbercheck(value) or listcheckbool or arraycheckbool)
    end

    return finalValue
end

function stringcheck(contents)
    contents = contents:trim()

    if string.sub(contents, 1, 1) ~= "\"" or string.sub(contents, string.len(contents), string.len(contents)) ~= "\"" then
        return false
    end
    local returnString = string.sub(contents, 2, string.len(contents)-1)
    -- returnString = string.gsub(returnString, "\\\"", "a")

    return (string.find(returnString, "\"") == nil)
end

function numbercheck(contents)
    contents = tostring(contents):trim()
    if string.sub(contents, 1, 1) == "\"" or string.sub(contents, string.len(contents), string.len(contents)) == "\"" then
        return false
    end
    
    local contentCheck1 = tostring(string.match("1.42", "[\-\+]?[0-9]*[\.[0-9]+]?") ~= nil)
    local contentCheck2 = (string.match(contents, "[\-\+]?[0-9]*[\.[0-9]+]?") == contents)
    
    return (contentCheck1 and contentCheck2)
end


return validJson
