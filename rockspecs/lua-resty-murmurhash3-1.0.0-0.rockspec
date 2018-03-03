package = "lua-resty-murmurhash3"
version = "1.0.0-0"
source = {
    url = "git://github.com/spacewander/lua-resty-murmurhash3",
    tag = "1.0.0",
}
description = {
    summary = "lua-resty-murmurhash3 - the Lua binding of murmurhash3 via LuaJIT FFI",
    detailed = "lua-resty-murmurhash3 - the Lua binding of murmurhash3 via LuaJIT FFI",
    homepage = "https://github.com/spacewander/lua-resty-murmuhash3",
    license = "MIT",
}
dependencies = {
    -- actually we need LuaJIT 2.1
    "lua >= 5.1",
}
build = {
    type = "command",
    build_command = "cmake . && cmake --build .",
    install = {
        lua = {
            murmurhash3 = "murmurhash3.lua",
        },
        lib = {
            libmurmurhash3 = "libmurmurhash3.so",
        },
    }
}
