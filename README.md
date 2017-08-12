## Name

lua-resty-murmurhash3 - the Lua binding of murmurhash3 via LuaJIT FFI

## When should I use it?

Murmurhash family has an awesome feature, it could hash data into a few bytes with fantasy speed.
The feature is useful when you want to count urls or anything similar.

Compared with Murmurhash2, Murmurhash3 has improved the collision resistance.
It also supports to provide 128 bits output.

Sometimes you don't need to use cryptographic hashes like MD5. They are relatively slow.

Here is a non-scientific benchmark comparing Murmurhash2/Murmurhash3/MD5:

---
Time used in processing 1e6 random generated 256 byte string:
* Murmurhash2(lua-resty-murmurhash2): 0.295s
* Murmurhash3(lua-resty-murmurhash3): 0.265s
* Murmurhash3, 128 bits(lua-resty-murmurhash3): 0.155s
* MD5(ngx.md5_bin): 1.585s

---

Murmurhash3(128 bits) is faster than Murmurhash3(32 bits) because of the modern processor's 64-bit multipliers and superscalar architecture.

## Synopsis

```lua
local mmh3 = require "murmurhash3"
local murmurhash3 = mmh3.murmurhash3
local murmurhash3_128 = mmh3.murmurhash3_128
local ts = {}
for _ = 1, 256 do
    table.insert(ts, math.random(65, 122))
end
local s = table.concat(ts)
local data
local start = ngx.now()
for _ = 1, 1e6 do
    data = murmurhash3(s)
    --data = murmurhash3_128(s)
end
ngx.update_time()
ngx.say(ngx.now() - start)
ngx.say(data)
```

## Methods

murmurhash3
---
`syntax: hash = mmh3.murmurhash3(string[, seed])`

Generate 32 bits hash from given string, with an optional seed(default 0).
The returned result is an unsigned integer represented by a Lua number.

murmurhash3_128
---
`syntax: hash = mmh3.murmurhash3_128(string[, seed])`

Generate 128 bits hash from given string, with an optional seed(default 0).
The returned result is represented by a 16 bytes long Lua string.
This version is optimized for x64 platform.

murmurhash3_128_x86
---
`syntax: hash = mmh3.murmurhash3_128_x86(string[, seed])`

Generate 128 bits hash from given string, with an optional seed(default 0).
The returned result is represented by a 16 bytes long Lua string.
This version is optimized for x86 platform and its output is different from `murmurhash3_128`.

## Installation

`cmake . && cmake --build .` to build the `libmurmurhash3` library, then copy it to your Nginx's PWD.
Also copy the `murmurhash3.lua` to your project, so that you could call those methods.
