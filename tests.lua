local validJson = require "validJson"

local expectedSpaces = 50

function assertEqual(testString, testExpected)

    testResult = validJson(testString)

    testString = testString .. " "

    testStringLen = string.len(testString)
    while testStringLen ~= expectedSpaces do
        testString = testString .. "."
        testStringLen = string.len(testString)
    end

    print(testString .. " " .. tostring(testResult == testExpected))
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


-- Array in Array test

test = "{\"test\": {}}"
assertEqual(test, true)
