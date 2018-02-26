local ffi = require "ffi"
local ffi_new = ffi.new
local ffi_string = ffi.string
local new_tab = require "table.new"
local io_open = io.open
local io_close = io.close
local cpath = package.cpath
local str_gmatch = string.gmatch
local str_match = string.match
local table_concat = table.concat
local error = error
local tonumber = tonumber


ffi.cdef[[
uint32_t MurmurHash3_x86_32  ( const void * key, int len, uint32_t seed);
void MurmurHash3_x86_128 ( const void * key, int len, uint32_t seed, void * out );
void MurmurHash3_x64_128 ( const void * key, int len, uint32_t seed, void * out );
]]

local function load_shared_lib(lib_name)
    local tried_paths = new_tab(32, 0)
    local i = 1

    for k, _ in str_gmatch(cpath, "[^;]+") do
        local dir = str_match(k, "(.*/)")
        local fpath = dir .. lib_name
        local f = io_open(fpath)
        if f ~= nil then
            io_close(f)
            tried_paths[i] = dir
            return ffi.load(fpath), tried_paths
        end
        tried_paths[i] = fpath
        i = i + 1
    end

    return nil, tried_paths
end

local lib_name = "libmurmurhash3"
if ffi.os == 'Windows' then
    lib_name = lib_name .. ".dll"
else
    lib_name = lib_name .. ".so"
end

local mmh3, tried_paths = load_shared_lib(lib_name)
if not mmh3 then
    tried_paths[#tried_paths + 1] =
        'tried above paths but can not load ' .. lib_name
    error(table_concat(tried_paths, '\n'))
end

local _M = {}

function _M.murmurhash3(key, seed)
    seed = seed or 0
    -- let LuaJIT throws bad eargument error for us
    return tonumber(mmh3.MurmurHash3_x86_32(key, #key, seed))
end

local out_128bit = ffi_new("unsigned char[?]", 16)

function _M.murmurhash3_128(key, seed)
    seed = seed or 0
    mmh3.MurmurHash3_x64_128(key, #key, seed, out_128bit)
    return ffi_string(out_128bit, 16)
end

function _M.murmurhash3_128_x86(key, seed)
    seed = seed or 0
    mmh3.MurmurHash3_x86_128(key, #key, seed, out_128bit)
    return ffi_string(out_128bit, 16)
end

return _M
