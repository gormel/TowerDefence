---@class ecstasy.System
---@field name string
---@field world ecstasy.World
---@field cmd_buffer ecstasy.CommandBuffer
---@operator call:ecstasy.System
local System = {}

---@param object table
---@return ecstasy.System
function System:new(object)
    self.__index = self
    assert(object, "Required parameters are not present")
    assert(object.world, "Required parameter `world` is not present")
    assert(object.cmd_buffer, "Required parameter `cmd_buffer` is not present")
    return setmetatable(object, self)
end

function System:init() end

---@param dt number
function System:execute(dt) end

function System:dispose() end

function System:late_dispose() end

setmetatable(System, {
    __call = function(cls, name)
        cls.__index = cls
        return setmetatable({ name = name }, cls)
    end
})

return System
