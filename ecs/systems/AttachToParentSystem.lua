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
        local offset = self.world:get_component(Components.AttachToParent, entity)
        local parent = self.world:get_component(Components.Parent, entity)
        local parent_position = self.world:safe_get_component(Components.Position, parent.entity)
        local parent_rotation = self.world:safe_get_component(Components.Rotation, parent.entity)
        if parent_position ~= nil and offset.sync_position then
            local position = self.world:get_or_add_component(Components.Position, entity)
            position.x = parent_position.x + offset.dx
            position.y = parent_position.y + offset.dy
            position.z = parent_position.z + offset.dz
        end

        if parent_rotation ~= nil and offset.sync_angle then
            local rotation = self.world:get_or_add_component(Components.Rotation, entity)
            rotation.angle = parent_rotation.angle + offset.da
        end
    end
end

return AttachToParentSystem