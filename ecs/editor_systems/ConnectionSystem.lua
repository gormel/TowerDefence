local ecstasy    = require "external.ecstasy"
local Components = require("ecs.components")
local EComponnets = require("ecs.editor_components")

local exc, inc   = ecstasy.exc, ecstasy.inc

---@class ConnectionSystem : ecstasy.System
local ConnectionSystem = ecstasy.System("ConnectionSystem")

function ConnectionSystem:init()
    self.connections = self.world:get_table(EComponnets.Connection)
    self.positions = self.world:get_table(Components.Position)
    self.rotations = self.world:get_table(Components.Rotation)

    self.filter = self.world:create_filter(EComponnets.Connection)
end

function ConnectionSystem:execute()
    for _, entity in self.filter:entities() do
        local connection = self.connections:get(entity)
        local a_pos = self.positions:safe_get(connection.a_entity)
        local b_pos = self.positions:safe_get(connection.b_entity)
        if a_pos ~= nil and b_pos ~= nil then
            local pos = self.positions:get_or_add(entity)
            pos.x = (a_pos.x + b_pos.x) / 2
            pos.y = (a_pos.y + b_pos.y) / 2
            pos.z = (a_pos.z + b_pos.z) / 2
        end

        local rotation = self.rotations:get_or_add(entity)
        rotation.angle = math.atan2(a_pos.y - b_pos.y, a_pos.x - b_pos.x)
    end
end

return ConnectionSystem
