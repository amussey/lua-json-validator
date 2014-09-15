local validJson = require "validJson"

local expectedSpaces = 60

function assertEqual(testString, testExpected)

    local testResult = validJson(testString)

    testString = testString .. " "

    testStringLen = string.len(testString)
    while testStringLen ~= expectedSpaces do
        testString = testString .. "."
        testStringLen = string.len(testString)
    end

    local expectedResult = "invalid?   "
    if testExpected then
        expectedResult = "valid?     "
    end

    local result = "fail"
    if testResult == testExpected then
        result = "pass"
    end

    print(testString .. " " .. expectedResult .. result)
end


local test = ""

-- Array Tests

test = "{}"
assertEqual(test, true)

test = "{asdf}"
assertEqual(test, false)

test = "{\"asdf\"}"
assertEqual(test, false)

test = "{\"asdf\":\"asdf\"}"
assertEqual(test, true)

test = "{     \"asdf\" : \"asdf\"    }"
assertEqual(test, true)

test = "{\"asdf\":true}"
assertEqual(test, true)

test = "{\"asdf\":null}"
assertEqual(test, true)

test = "{\"asdf\":false}"
assertEqual(test, true)

test = "{123124:\"asdf\"}"
assertEqual(test, false)

test = "{\"asdf\":123123}"
assertEqual(test, true)

test = "{asdf, asdf}"
assertEqual(test, false)

test = "{\"asdf\", \"asdf\"}"
assertEqual(test, false)

test = "{asdf, \"asdf\"}"
assertEqual(test, false)

test = "{\"asdf\":\"asdf\", \"asdf\":\"asdf\"}"
assertEqual(test, true)

test = "{123124:\"asdf\", 123124:\"asdf\"}"
assertEqual(test, false)

test = "{\"asdf\":123123, \"asdf\":123123}"
assertEqual(test, true)

test = "{\"asdf\":123123, 123124:\"asdf\"}"
assertEqual(test, false)

test = "{123124:\"asdf\", \"asdf\":123123}"
assertEqual(test, false)

test = "{123124:\"asdf\", \"asdf\":123123, \"asdf\":\"asdf\"}"
assertEqual(test, false)


-- List Tests

test = "[]"
assertEqual(test, true)

test = "[123]"
assertEqual(test, true)

test = "[ab, 123]"
assertEqual(test, false)

test = "[\"asdf\"]"
assertEqual(test, true)

test = "[\"123\", 123]"
assertEqual(test, true)

test = "[\"asdf\", asdf]"
assertEqual(test, false)

test = "[\"asdf\", 123]"
assertEqual(test, true)

test = "[\"asdf\", asdf]"
assertEqual(test, false)

test = "[\"af\", \"af\", \"af\"]"
assertEqual(test, true)


-- Array in List test

test = "[{}]"
assertEqual(test, true)

test = "[{asdf}]"
assertEqual(test, false)

test = "[{123}]"
assertEqual(test, false)

test = "[{123:\"test\"}]"
assertEqual(test, false)

test = "[{\"test\":\"test\"}]"
assertEqual(test, true)

test = "[{\"test\":2134}]"
assertEqual(test, true)

test = "[{\"test\":\"test\", 123:\"test\"}]"
assertEqual(test, false)

test = "[{123:\"test\", \"test\":\"test\"}]"
assertEqual(test, false)

test = "[{\"test\":\"test\"}]"
assertEqual(test, true)

test = "[{\"test\":\"test\", \"test\":\"test\"}]"
assertEqual(test, true)

test = "[{\"test\":2134, \"test\":2134}]"
assertEqual(test, true)

test = "[{\"test\":2134, \"test\":2134,  \"test\":\"test\"}]"
assertEqual(test, true)

test = "[{}, 123]"
assertEqual(test, true)

test = "[{}, \"asdf\"]"
assertEqual(test, true)


-- List in Array test

test = "{\"test\": []}"
assertEqual(test, true)


-- List in List test

test = "[[]]"
assertEqual(test, true)

test = "[[[]]]"
assertEqual(test, true)

test = "[[[]]]"
assertEqual(test, true)


-- Array in Array test

test = "{\"test\": {}}"
assertEqual(test, true)

test = "{\"test\": {asdf}}"
assertEqual(test, false)

test = "{\"test\": {\"asdfsdf\": \"asdfasdf\"}}"
assertEqual(test, true)


-- Various other complex combinations

test = "[[[{}], {}, {\"asdf\": \"woot\"}]]"
assertEqual(test, true)
