local World = require "external.world"
local System = require "external.system"
local SystemsList = require "external.systems_list"
local operators = require "external.operators"

return {
    World = World,
    System = System,
    SystemsList = SystemsList,
    inc = operators.inc,
    exc = operators.exc,
    added = operators.added,
    removed = operators.removed
}
