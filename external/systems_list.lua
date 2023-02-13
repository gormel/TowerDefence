local CommandBuffer = require "external.command_buffer"
local util = require "external.util"

---@class ecstasy.SystemsList
---@field world ecstasy.World
---@field cmd_buffer ecstasy.CommandBuffer
---@field _systems ecstasy.System[]
---@operator call:ecstasy.SystemsList
local SystemsList = {}

function SystemsList:init()
    for _, system in ipairs(self._systems) do
        system:init()
    end
end

---@param type ecstasy.System
---@param params? table
function SystemsList:register(type, params)
    params = params or {}
    params.world = self.world
    params.cmd_buffer = self.cmd_buffer
    local system = type:new(params)
    table.insert(self._systems, system)
end

---@param dt number
function SystemsList:execute(dt)
    self.cmd_buffer:clear()
    for _, system in ipairs(self._systems) do
        system:execute(dt)
    end
    self.cmd_buffer:execute()
end

function SystemsList:dispose()
    for _, system in ipairs(self._systems) do
        system:dispose()
    end
    for _, system in ipairs(self._systems) do
        system:late_dispose()
    end
    util.clear_table(self._systems)
end

setmetatable(SystemsList, {
    __call = function(cls, object)
        cls.__index = cls
        assert(object, "Required parameters are not present")
        assert(object.world, "Required parameter `world` is not present")
        object._systems = object._systems or {}
        object.cmd_buffer = object.cmd_buffer or CommandBuffer({ world = object.world })
        return setmetatable(object, cls)
    end
})

return SystemsList
