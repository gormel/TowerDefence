local ecstasy = require "external.ecstasy"
local Components = require("ecs.components")
local EComponents = require "ecs.editor_components"

local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed

---@class ClearConnectionSystem : ecstasy.System
local ClearConnectionSystem = ecstasy.System("ClearConnectionSystem")

function ClearConnectionSystem:init()
    self.destroyeds = self.world:get_table(Components.Destroyed)
    self.connections = self.world:get_table(EComponents.Connection)

    self.filter = self.world:create_filter(EComponents.Connection, exc(Components.Destroyed))
end

function ClearConnectionSystem:execute()
    for _, entity in self.filter:reverse_entities() do
        local connection = self.connections:get(entity)
        if self.destroyeds:has(connection.a_entity) or self.destroyeds:has(connection.b_entity) then
            self.destroyeds:add(entity)
        end
    end
end

return ClearConnectionSystem