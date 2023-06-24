local util = require "external.util"
local operators = require "external.operators"

---@class ecstasy.Filter
---@field initialized boolean
---@field world ecstasy.World
---@field conditions ecstasy.filter_condition[]
---@field _dependency_types table<ecstasy.Component, boolean>
---@field _conditions_tables ecstasy.ComponentsTable[]
local Filter = {}

---@param self ecstasy.Filter
local function init(self)
    self._conditions_tables = {}
    self._dependency_types = {}
    for _, condition in ipairs(self.conditions) do
        self._dependency_types[condition.type] = true
        table.insert(self._conditions_tables, self.world:get_table(condition.type))
    end
    self.initialized = true
end

---@param self ecstasy.Filter
---@param entity number
---@param start_index number
local function check_conditions(self, entity, start_index)
    for i = start_index, #self.conditions do
        local condition = self.conditions[i]
        local components_table = self._conditions_tables[i]
        if condition.operator == operators.OPERATOR_INCLUDE
            and not components_table:has(entity) then
            return false
        elseif condition.operator == operators.OPERATOR_EXCLUDE
            and components_table:has(entity) then
            return false
        end
    end
    return true
end

---@param self ecstasy.Filter
---@param index? number
---@return number?
---@return number?
local function iterator(self, index)
    local base_table = self._conditions_tables[1]
    index = index or 0
    for i = index + 1, #base_table._entities do
        local entity = base_table._entities[i]
        if check_conditions(self, entity, 2) then
            return i, entity
        end
    end
end

---@return fun(table: ecstasy.Filter, index?: number):number, number
---@return ecstasy.Filter
function Filter:entities()
    if not self.initialized then
        init(self)
    end
    return iterator, self
end

---@param self ecstasy.Filter
---@param index? number
---@return number?
---@return number?
local function reverse_iterator(self, index)
    local base_table = self._conditions_tables[1]
    index = index or #base_table._entities + 1
    for i = index - 1, 1, -1 do
        local entity = base_table._entities[i]
        if check_conditions(self, entity, 2) then
            return i, entity
        end
    end
end

---@return fun(table: ecstasy.Filter, index?: number):number, number
---@return ecstasy.Filter
function Filter:reverse_entities()
    if not self.initialized then
        init(self)
    end
    return reverse_iterator, self
end

---@return boolean
function Filter:empty()
    if not self.initialized then
        init(self)
    end
    return iterator(self, 0) == nil
end

---@param type ecstasy.Component
---@return boolean
function Filter:depends_on(type)
    return self._dependency_types[type] ~= nil
end

function Filter:dispose()
    util.clear_table(self.conditions)
    if self.initialized then
        util.clear_table(self._dependency_types)
        util.clear_table(self._conditions_tables)
    end
end

setmetatable(Filter, {
    __call = function(cls, object)
        cls.__index = cls
        assert(object, "Required parameters are not present")
        assert(object.world, "Required parameter `world` is not present")
        assert(object.conditions, "Required parameter `conditions` is not present")
        assert(#object.conditions > 0, "Filter must contain at least one condition")
        assert(object.conditions[1].operator == operators.OPERATOR_INCLUDE,
            "First filter condition must be of type `include`")
        object.initialized = false
        return setmetatable(object, cls)
    end
})

return Filter
