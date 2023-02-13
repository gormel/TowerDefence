---@class ecstasy.filter_condition
---@field operator number
---@field type ecstasy.Component

local M = {}

M.OPERATOR_INCLUDE = 0
M.OPERATOR_EXCLUDE = 1
M.OPERATOR_ADDED = 2
M.OPERATOR_REMOVED = 3

---@param type ecstasy.Component
---@return ecstasy.filter_condition
function M.inc(type)
    return { operator = M.OPERATOR_INCLUDE, type = type }
end

---@param type ecstasy.Component
---@return ecstasy.filter_condition
function M.exc(type)
    return { operator = M.OPERATOR_EXCLUDE, type = type }
end

---@param type ecstasy.Component
---@return ecstasy.filter_condition
function M.added(type)
    return { operator = M.OPERATOR_ADDED, type = type }
end

---@param type ecstasy.Component
---@return ecstasy.filter_condition
function M.removed(type)
    return { operator = M.OPERATOR_REMOVED, type = type }
end

return M
