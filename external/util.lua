local operators = require "external.operators"

local M = {}

---@param object table
function M.clear_table(object)
    for k, _ in pairs(object) do
        object[k] = nil
    end
end

---@param ... ecstasy.filter_condition|ecstasy.Component
---@return ecstasy.filter_condition[]
function M.ensure_conditions_list(...)
    ---@type ecstasy.filter_condition[]
    local conditions = {}
    for _, condition in ipairs({ ... }) do
        if condition.operator then
            table.insert(conditions, condition)
        else
            table.insert(conditions, operators.inc(condition--[[@as ecstasy.Component]] ))
        end
    end
    return conditions
end

---@param list_a ecstasy.filter_condition[]
---@param list_b ecstasy.filter_condition[]
---@return boolean
function M.compare_conditions_lists(list_a, list_b)
    if #list_a ~= #list_b then
        return false
    end
    for i, condition_a in ipairs(list_a) do
        local condition_b = list_b[i]
        if condition_a.operator ~= condition_b.operator or condition_a.type ~= condition_b.type then
            return false
        end
    end
    return true
end

---@generic T
---@param tbl T[]
---@param index number
---@return number?
---@return T?
local function ripairs_iter(tbl, index)
    index = index - 1
    local value = tbl[index]
    if value then
        return index, value
    end
end

---@generic T
---@param tbl T[]
---@return fun(tbl: T[], index?: number):number, T
---@return T[]
---@return number
function M.ripairs(tbl)
    return ripairs_iter, tbl, #tbl + 1
end

return M
