local LRU = require "LRU"

local lru = LRU.new()
lru:init({})
lru:push(1, "key1")
lru:push(2, "key2")
lru:push(3, "key3")
lru:print()

print(**********************)

local value1 = lru:get(1)
print("index 1:", value1)
lru:update(2, "update2")
lru:print()
