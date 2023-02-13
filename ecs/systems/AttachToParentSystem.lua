local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class AttachToParentSystem : ecstasy.System
local AttachToParentSystem = ecstasy.System("AttachToParentSystem")

function AttachToParentSystem:init()
    self.filter = self.world:create_filter(Components.Parent, Components.AttachToParent)
end

function AttachToParentSystem:execute()
    for _, entity in self.filter:entities() do
        local parent = self.world:get_component(Components.Parent, entity)
        local parent_position = self.world:get_component(Components.Position, parent.entity)
        local parent_rotation = self.world:get_or_add_component(Components.Rotation, parent.entity)
        if (parent_position ~= nil) then
            local position = self.world:get_or_add_component(Components.Position, entity)
            local offset = self.world:get_component(Components.AttachToParent, entity)
            local rotation = self.world:get_or_add_component(Components.Rotation, entity)

            position.x = parent_position.x + offset.dx
            position.y = parent_position.y + offset.dy

            rotation.angle = parent_rotation.angle + offset.drot
        end
    end
end

return AttachToParentSystem