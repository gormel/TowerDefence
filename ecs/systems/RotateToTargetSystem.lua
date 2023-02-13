local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class RotateToTargetSystem : ecstasy.System
local RotateToTargetSystem = ecstasy.System("RotateToTargetSystem")

function RotateToTargetSystem:init()
    self.positions = self.world:get_table(Components.Position)
    self.rotations = self.world:get_table(Components.Rotation)
    self.targets = self.world:get_table(Components.Target)

    self.filter = self.world:create_filter(Components.RotateToTarget, Components.Target)
end

function RotateToTargetSystem:execute()
    for _, entity in self.filter:entities() do
        local target = self.targets:get(entity)
        if self.positions:has(target.target) then
            local target_pos = self.positions:get(target.target)
            local pos = self.positions:get(entity)

            local dx = target_pos.x - pos.x
            local dy = target_pos.y - pos.y
            local angle = math.atan2(dy, dx) - math.pi / 2

            local rot = self.rotations:get_or_add(entity)
            rot.angle = angle
        end
    end
end

return RotateToTargetSystem