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

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
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

    local searchChar = ""
    local failChar = ""

    if string.sub(contents, js, js) == "{" then
        searchChar = "}"
        failChar = "]"
    elseif string.sub(contents, js, js) == "[" then
        searchChar = "]"
        failChar = "}"
    else
        return false
    end


    while string.sub(contents, je, je) ~= searchChar and string.sub(contents, je, je) ~= "" do

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

        je = je + 1
    end

    if string.sub(contents, je, je) == searchChar then
        -- the current array or list is from js to je


        -- if it's a list, validate it and remove it.
        arrayCheckBool = arrayCheck(string.sub(contents, js, je))
        listCheckBool = listCheck(string.sub(contents, js, je))


        checkBool = arrayCheckBool or listCheckBool
        if checkBool then
            -- contents without the current value.
            contents = string.sub(contents, 1, js-1) .. "\"\"" .. string.sub(contents, je+1, string.len(contents))
            return isValid(contents)
        else
            return false
        end
    end
end

function arrayCheck(contents)
    contents = contents:trim()
    if string.sub(contents, 1, 1) == "{" and string.sub(contents, string.len(contents), string.len(contents)) == "}" then
        contents = string.sub(contents, 2, string.len(contents)-1):trim()
    else
        return false
    end

    if contents == "" then
        return true
    end

    contents = contents:split(",")

    local finalValue = true
    for _,value in pairs(contents) do
        finalValue = finalValue and arrayItemCheck(value)
    end

    return finalValue
end

function arrayItemCheck(contents)
    contents = contents:split(":")

    if tablelength(contents) ~= 2 then
        -- There is not a key-value pair.
        return false
    end
    contents[1] = contents[1]:trim()
    contents[2] = contents[2]:trim()

    local contentValue1 = stringCheck(contents[1])

    local value = contents[2]

    local listcheckbool = false
    local arraycheckbool = false
    if string.sub(value, 1, 1) == "{" and string.sub(value, string.len(value), string.len(value)) == "}" then
        arraycheckbool = arrayCheck(string.sub(value, 2, string.len(value)-1))
    elseif string.sub(value, 1, 1) == "[" and string.sub(value, string.len(value), string.len(value)) == "]" then
        listcheckbool = listCheck(string.sub(value, 2, string.len(value)-1))
    end
    local contentValue2 = (stringCheck(value) or numberCheck(value) or boolCheck(value) or nullCheck(value) or listcheckbool or arraycheckbool)

    return contentValue1 and contentValue2
end




function listCheck(contents)
    contents = contents:trim()
    if string.sub(contents, 1, 1) == "[" and string.sub(contents, string.len(contents), string.len(contents)) == "]" then
        contents = string.sub(contents, 2, string.len(contents)-1):trim()
    else
        return false
    end
    
    if contents == "" then
        return true
    end

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

        finalValue = finalValue and (stringCheck(value) or numberCheck(value) or boolCheck(value) or nullCheck(value) or listcheckbool or arraycheckbool)
    end

    return finalValue
end

function stringCheck(contents)
    contents = contents:trim()

    if string.sub(contents, 1, 1) ~= "\"" or string.sub(contents, string.len(contents), string.len(contents)) ~= "\"" then
        return false
    end
    local returnString = string.sub(contents, 2, string.len(contents)-1)

    return (string.find(returnString, "\"") == nil)
end

function numberCheck(contents)
    contents = tostring(contents):trim()
    if string.sub(contents, 1, 1) == "\"" or string.sub(contents, string.len(contents), string.len(contents)) == "\"" then
        return false
    end
    
    local contentCheck1 = tostring(string.match("1.42", "[\-\+]?[0-9]*[\.[0-9]+]?") ~= nil)
    local contentCheck2 = (string.match(contents, "[\-\+]?[0-9]*[\.[0-9]+]?") == contents)
    
    return (contentCheck1 and contentCheck2)
end

function boolCheck(contents)
    contents = tostring(contents):trim()
    return contents == "true" or contents == "false"
end

function nullCheck(contents)
    contents = tostring(contents):trim()
    return contents == "null"
end


return validJson
