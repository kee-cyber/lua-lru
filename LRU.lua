--- Least Recently Used(LRU)
--- Create by xieyq
--- DateTime:2025/4/8 11:45
local class = require "class"

-- oop object
local LRUCache = class()

-- Node struct
local _Node = function (key, value)
    return {
        key = key,
        value = value,
        count = 0,          -- use count
        time = 0,           -- Finally use timestamp
        prev = nil,
        next = nil
    }
end

-- 创建新缓存
function LRUCache:ctor(capacity)
    self.capacity = capacity or 10  -- default size 10
    self.size = 0
    self.hash = {}                  -- table<key, Node>
    self.head = _Node()             -- link head
    self.head.next = self.head
    self.head.prev = self.head
end

function LRUCache:init(cache)
    self.cache = cache
    for key,cache in pairs(cache) do
        self.hash[key] = self:create(key, value)
    end
end

function LRUCache:insert(node)
    if self.head.next == node then return end  -- if is head
    node.prev.next = node.next -- disconnect the old node
    node.next.prev = node.prev

    -- insert to head
    node.next = self.head.next
    node.prev = self.head
    self.head.next.prev = node
    self.head.next = node
end

function LRUCache:remove(node)
    node.prev.next = node.next
    node.next.prev = node.prev
    self.hash[node.key] = nil
    self.cache[node.key] = nil
    self.size = self.size - 1
end

function LRUCache:pop()
    local node = self.tail.prev
    self:remove(node)
    return node.key
end

function LRUCache:create(key, value)
    local node = _Node(key, value)

    node.next = self.head.next
    node.prev = self.head
    self.head.next.prev = node
    self.head.next = node
    self.size = self.size + 1
    return node
end

------------------interface---------
function LRUCache:update(key, value)
    local node = self.hash[key]
    if node then
        node.value = value
        self:insert(node)
    end
end

function LRUCache:push(key, value)
    local node = self.hash[key]
    if node then
        node.value = value
        self:insert(node)
        return
    end

    node = self:create(key, value)
    self.cache[key] = value
    self.hash[key] = node
    if self.size > self.capacity then
        self:pop()
    end
end

function LRUCache:get(key)
    local node = self.hash[key]
    if not node then
        return
    end

    self:insert(node)
    node.count = node.count + 1
    return node.value
end

function LRUCache:print()
    local current = self.head.next
    while current ~= self.head do
        print("=====", current.key, current.value)
        current = current.next
    end
end

function LRUCache:evict()
    if self.size <= 0 then return end
    local remove = self.head.next
    local min = remove.count
    local minTime = remove.time

    local current = remove.next
    while current.next ~= self.head.prev do
        if current.key then
            if current.count < min then
                min = current.count
                minTime = current.time
                remove = current
            elseif current.count == min then
                if current.time < minTime then
                    min = current.count
                    minTime = current.time
                    remove = current
                end
            end
        end
        current = current.next
    end

    self:remove(remove)
end

return LRUCache
