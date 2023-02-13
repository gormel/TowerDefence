local util = require "external.util"

-- Temporary workaround
---@class ecstasy.GenericComponentsTable<T> : { type: T, (get_size: fun():number), (entities: fun(self: ecstasy.GenericComponentsTable<T>):(fun(table: number[], i?: number):(number, number))), (reverse_entities: fun(self: ecstasy.GenericComponentsTable<T>):(fun(table: number[], i?: number):(number, number))), (components: fun(self: ecstasy.GenericComponentsTable<T>):(fun(table: T[], i?: number):(number, T))), (reverse_components: fun(self: ecstasy.GenericComponentsTable<T>):(fun(table: T[], i?: number):(number, T))), (entries: fun(self: ecstasy.GenericComponentsTable<T>):(fun(table: ecstasy.GenericComponentsTable<T>, i?: number):(number, number, T))), (reverse_entries: fun(self: ecstasy.GenericComponentsTable<T>):(fun(table: ecstasy.GenericComponentsTable<T>, i?: number):(number, number, T))), (get_entities_raw_array: fun(self: ecstasy.GenericComponentsTable<T>):number[]), (get_components_raw_array: fun(self: ecstasy.GenericComponentsTable<T>):T[]), (get: fun(self: ecstasy.GenericComponentsTable<T>, entity: number):T), (safe_get: fun(self: ecstasy.GenericComponentsTable<T>, entity: number):T?), (get_or_add: fun(self: ecstasy.GenericComponentsTable<T>, entity: number):T), (add: fun(self: ecstasy.GenericComponentsTable<T>, entity: number):T), (set: fun(self: ecstasy.GenericComponentsTable<T>, entity: number, component: T):nil), (has: fun(self: ecstasy.GenericComponentsTable<T>, entity: number):bool), (del: fun(self: ecstasy.GenericComponentsTable<T>, entity: number):bool), (clear: fun(self: ecstasy.GenericComponentsTable<T>):nil) }

---@class ecstasy.ComponentsTable
---@field world ecstasy.World
---@field type ecstasy.Component
---@field _entities number[] readonly
---@field _components ecstasy.Component[] readonly
---@field _map table<number, number>
---@operator call:ecstasy.ComponentsTable
local ComponentsTable = {}

---@return number
function ComponentsTable:get_size()
    return #self._components
end

---@return fun(table: number[], index?: number):number, number
---@return number[]
---@return number
function ComponentsTable:entities()
    return ipairs(self._entities)
end

---@return fun(table: number[], index?: number):number, number
---@return number[]
---@return number
function ComponentsTable:reverse_entities()
    return util.ripairs(self._entities)
end

---@return fun(table: ecstasy.Component[], index?: number):number, ecstasy.Component
---@return ecstasy.Component[]
---@return number
function ComponentsTable:components()
    return ipairs(self._components)
end

---@return fun(table: ecstasy.Component[], index?: number):number, ecstasy.Component
---@return ecstasy.Component[]
---@return number
function ComponentsTable:reverse_components()
    return ipairs(self._components)
end

---@param components_table ecstasy.ComponentsTable
---@param index? number
---@return number?
---@return number?
---@return ecstasy.Component?
local function entries_iterator(components_table, index)
    index = index + 1
    local component = components_table._components[index]
    if component then
        return index, components_table._entities[index], component
    end
end

---@return fun(table: ecstasy.ComponentsTable, index?: number):number, number, ecstasy.Component
---@return ecstasy.ComponentsTable
---@return number
function ComponentsTable:entries()
    return entries_iterator, self, 0
end

---@param components_table ecstasy.ComponentsTable
---@param index? number
---@return number?
---@return number?
---@return ecstasy.Component?
local function reverse_entries_iterator(components_table, index)
    index = index - 1
    local component = components_table._components[index]
    if component then
        return index, components_table._entities[index], component
    end
end

---@return fun(table: ecstasy.ComponentsTable, index?: number):number, number, ecstasy.Component
---@return ecstasy.ComponentsTable
---@return number
function ComponentsTable:reverse_entries()
    return reverse_entries_iterator, self, #self._components + 1
end

---@return number[] readonly
function ComponentsTable:get_entities_raw_array()
    return self._entities
end

---@return ecstasy.Component[] readonly
function ComponentsTable:get_components_raw_array()
    return self._components
end

---@param entity number
---@return ecstasy.Component
function ComponentsTable:get(entity)
    local index = self._map[entity]
    if index then
        return self._components[index]
    else
        error("The component doesn't exist")
    end
end

---@param entity number
---@return ecstasy.Component?
function ComponentsTable:safe_get(entity)
    local index = self._map[entity]
    if index then
        return self._components[index]
    end
end

---@param entity number
---@return ecstasy.Component
function ComponentsTable:get_or_add(entity)
    if self:has(entity) then
        return self:get(entity)
    else
        return self:add(entity)
    end
end

---@param entity  number
---@return ecstasy.Component
function ComponentsTable:add(entity)
    assert(not self._map[entity], "The component already exists and can't be overwritten")
    local component = self.world:create_component(self.type)
    table.insert(self._components, component)
    table.insert(self._entities, entity)
    self._map[entity] = #self._components
    self.world:on_component_added(entity, self.type)
    return component
end

---@param entity number
---@param component ecstasy.Component
function ComponentsTable:set(entity, component)
    assert(not self._map[entity], "The component already exists and can't be overwritten")
    table.insert(self._components, component)
    table.insert(self._entities, entity)
    self._map[entity] = #self._components
    self.world:on_component_added(entity, self.type)
end

---@param entity number
---@return boolean
function ComponentsTable:has(entity)
    return self._map[entity] ~= nil
end

---@param entity  number
---@return boolean
function ComponentsTable:del(entity)
    local index = self._map[entity]
    if index then
        self.world:on_component_removing(entity, self.type)
        self._map[entity] = nil
        local component = self._components[index]
        table.remove(self._components, index)
        table.remove(self._entities, index)
        self.world:release_component(self.type, component)
        for key, dense_index in pairs(self._map) do
            if dense_index >= index then
                self._map[key] = dense_index - 1
            end
        end
        self.world:on_component_removed(entity, self.type)
        return true
    end
    return false
end

function ComponentsTable:clear()
    util.clear_table(self._map)
    for i = 1, #self._components do
        self.world:release_component(self.type, self._components[i])
        self._components[i] = nil
        self._entities[i] = nil
    end
end

setmetatable(ComponentsTable, {
    __call = function(cls, object)
        cls.__index = cls
        assert(object, "Required parameters are not present")
        assert(object.world, "Required parameter `world` is not present")
        assert(object.type, "Required parameter `type` is not present")
        object._components = {}
        object._entities = {}
        object._map = {}
        return setmetatable(object, cls)
    end
})

return ComponentsTable
