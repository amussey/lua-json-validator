# Lua JSON Validator

A Lua module for validating JSON.

## Usage Examples

To validate JSON, import the module:

```lua
local validJson = require "validJson"

if validJson(jsonString) then
    -- interact with valid JSON
else
    -- report invalid JSON
end
```

If you want to use this module on webscript.io, simply import the module using the repo name:

```lua
local validJson = require "amussey.com/lua-json-validator/validJson"

if validJson(jsonString) then
    -- interact with valid JSON
else
    -- report invalid JSON
end
```

## Unit Tests

To run the tests on the code, run:

```bash
lua tests.lua
```
