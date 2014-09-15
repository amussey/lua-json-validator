function jsonstring(jsonstring)
    jsonstring = jsonstring:trim()
    returnString = string.sub(jsonstring, 2, string.len(jsonstring)-1)
    if string.sub(jsonstring, 1, 1) == "{" and string.sub(jsonstring, string.len(jsonstring), string.len(jsonstring)) == "}" then
        return arraycheck(returnString)
    elseif string.sub(jsonstring, 1, 1) == "[" and string.sub(jsonstring, string.len(jsonstring), string.len(jsonstring)) == "]" then
        return listcheck(returnString)
    end

    return false
end

function parse_content(contents)

end


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


function arraycheck(contents)
    contents = contents:trim()
    if contents == "" then
        return true
    end

    contents = contents:split(",")

    local finalValue = true
    for _,value in pairs(contents) do
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

    local contentValue1 = stringcheck(contents[1])
    local contentValue2 = (stringcheck(contents[2]) or numbercheck(contents[2]))

    return contentValue1 and contentValue2
end

function listcheck(contents)
    contents = contents:trim()
    if contents == "" then
        return true
    end
    contents = contents:split(",")

    local finalValue = true
    for _,value in pairs(contents) do
        finalValue = finalValue and (stringcheck(value) or numbercheck(value))
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
