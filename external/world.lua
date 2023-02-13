local ComponentsTable = require "external.components_table"
local Filter = require "external.filter"
local operators = require "external.operators"
local util = require "external.util"

---@class ecstasy.Component
---@field reset? function

---@class ecstasy.World
---@field _tables table<ecstasy.Component, ecstasy.ComponentsTable>
---@field _pools table<ecstasy.Component, ecstasy.Component[]>
---@field _filters ecstasy.Filter[]
---@operator call:ecstasy.World
local World = {
    ---@type number
    current_entity_id = 0
}

---@param object? table
---@return ecstasy.World
function World:new(object)
    self.__index = self
    object = object or {}
    object._tables = object._tables or {}
    object._pools = object._pools or {}
    object._filters = object._filters or {}
    return setmetatable(object, self)
end

---@param value number
function World:set_current_entity_id(value)
    self.current_entity_id = value
end

---@return number
function World:new_entity()
    self.current_entity_id = self.current_entity_id + 1
    return self.current_entity_id
end

---@generic T : ecstasy.Component
---@param self ecstasy.World
---@param type T
---@return T[]
local function get_pool(self, type)
    if not self._pools[type] then
        self._pools[type] = {}
    end
    return self._pools[type]
end

---@param component ecstasy.Component
local function reset_component_state(component)
    if component.reset ~= nil then
        component:reset()
    else
        for k, _ in pairs(component) do
            component[k] = nil
        end
    end
end

---@generic T : ecstasy.Component
---@param type T
---@return T
function World:create_component(type)
    local pool = get_pool(self, type)
    if #pool > 0 then
        local component = table.remove(pool)
        reset_component_state(component)
        return component
    end
    local component = setmetatable({}, { __index = type })
    reset_component_state(component)
    return component
end

---@generic T : ecstasy.Component
---@param type T
---@param component T
function World:release_component(type, component)
    local pool = get_pool(self, type)
    table.insert(pool, component);
end

---@generic T
---@param type T
---@return ecstasy.GenericComponentsTable<T>
function World:get_table(type)
    if not self._tables[type] then
        self._tables[type] = ComponentsTable({ type = type, world = self })
    end
    return self._tables[type]
end

---@param type ecstasy.Component
---@return boolean
function World:has_component(type, entity)
    return self:get_table(type):has(entity)
end

---@generic T
---@param type T
---@param entity number
---@return T
function World:get_component(type, entity)
    return self:get_table(type):get(entity)
end

---@generic T
---@param type T
---@param entity number
---@return T?
function World:safe_get_component(type, entity)
    return self:get_table(type):safe_get(entity)
end

---@generic T
---@param type T
---@param entity number
---@return T
function World:get_or_add_component(type, entity)
    local components_table = self:get_table(type)
    return components_table:get_or_add(entity)
end

---@generic T
---@param type T
---@param entity number
---@return T
function World:add_component(type, entity)
    local components_table = self:get_table(type)
    return components_table:add(entity)
end

---@generic T
---@param type T
---@param entity number
---@return boolean
function World:del_component(type, entity)
    return self:get_table(type):del(entity)
end

---@param entity number
---@return boolean
function World:del_entity(entity)
    local result = false
    for _, components_table in pairs(self._tables) do
        if components_table:has(entity) then
            result = components_table:del(entity) and result
        end
    end
    return result
end

---@param ... ecstasy.filter_condition|ecstasy.Component
function World:create_filter(...)
    local conditions = util.ensure_conditions_list(...)
    for _, filter in ipairs(self._filters) do
        if util.compare_conditions_lists(conditions, filter.conditions) then
            return filter
        end
    end
    local filter = Filter({ world = self, conditions = conditions })
    table.insert(self._filters, filter)
    return filter
end

---@param entity number
---@param type ecstasy.Component
function World:on_component_added(entity, type) end

---@param entity number
---@param type ecstasy.Component
function World:on_component_removing(entity, type) end

---@param entity number
---@param type ecstasy.Component
function World:on_component_removed(entity, type) end

function World:clear()
    for _, components_table in pairs(self._tables) do
        components_table:clear()
    end
end

function World:dispose()
    self:clear()
    util.clear_table(self._tables)
    for _, pool in pairs(self._pools) do
        util.clear_table(pool)
    end
    util.clear_table(self._pools)
    for _, filter in ipairs(self._filters) do
        filter:dispose()
    end
    util.clear_table(self._filters)
end

setmetatable(World, {
    __call = function(cls, object)
        return cls:new(object)
    end
})

return World
