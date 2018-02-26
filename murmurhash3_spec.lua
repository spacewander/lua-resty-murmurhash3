local mmh3 = require "murmurhash3"
local murmurhash3 = mmh3.murmurhash3
local murmurhash3_128 = mmh3.murmurhash3_128

local function assert_cmd_success(cmd)
    local exit = os.execute(cmd)
    -- The return value from os.execute of different LuaJIT version is
    -- different, because of the compatibility with Lua 5.2.
    if exit ~= 0 and exit ~= true then
        assert.is_true(false)
    end
    assert.is_true(true)
end

it('murmurhash3', function()
    local data_fn = "data.txt"
    os.execute("python generate_fixture.py " .. data_fn)
    local f = io.open(data_fn)
    local luajit_32bit_out = io.open("luajit_32.out", "w")
    local luajit_128bit_out = io.open("luajit_128.out", "w")
    local seed = 0
    for line in f:lines() do
        luajit_32bit_out:write(murmurhash3(line, seed) .. "\n")
        luajit_128bit_out:write(murmurhash3_128(line, seed) .. "\n")
        seed = seed + 1
    end
    luajit_32bit_out:close()
    luajit_128bit_out:close()
    assert_cmd_success("diff -au luajit_32.out python_32.out")
    assert_cmd_success("diff -au luajit_128.out python_128.out")
end)
