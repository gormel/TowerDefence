local util = require "external.util"

local null = {}

---@class ecstasy.CommandBuffer
---@field world ecstasy.World
---@field _entities_to_delete number[]
---@field _components_to_delete ecstasy.Component[]
---@operator call:ecstasy.CommandBuffer
local CommandBuffer = {}

---@param type ecstasy.Component
---@param entity number
function CommandBuffer:del_component(type, entity)
    table.insert(self._components_to_delete, type)
    table.insert(self._entities_to_delete, entity)
end

---@param entity number
function CommandBuffer:del_entity(entity)
    table.insert(self._components_to_delete, null)
    table.insert(self._entities_to_delete, entity)
end

function CommandBuffer:execute()
    for i = 1, #self._entities_to_delete do
        local entity = self._entities_to_delete[i];
        local component_type = self._components_to_delete[i];
        if component_type == null then
            self.world:del_entity(entity)
        else
            self.world:del_component(component_type, entity)
        end
    end
    self:clear()
end

function CommandBuffer:clear()
    util.clear_table(self._entities_to_delete)
    util.clear_table(self._components_to_delete)
end

function CommandBuffer:dispose()
    self:clear()
end

setmetatable(CommandBuffer, {
    __call = function(cls, object)
        cls.__index = cls
        assert(object, "Required parameters are not present")
        assert(object.world, "Required parameter `world` is not present")
        object._entities_to_delete = object._entities_to_delete or {}
        object._components_to_delete = object._components_to_delete or {}
        return setmetatable(object, cls)
    end
})

return CommandBuffer
