local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class FreeOutOfViewTargetSystem : ecstasy.System
local FreeOutOfViewTargetSystem = ecstasy.System("FreeOutOfViewTargetSystem")

function FreeOutOfViewTargetSystem:init()
    self.targets = self.world:get_table(Components.Target)
    self.view_radiuses = self.world:get_table(Components.ViewRadius)
    self.positions = self.world:get_table(Components.Position)

    self.filter = self.world:create_filter(Components.FreeOutOfViewTarget, Components.Target, Components.ViewRadius, Components.Position)
end

function FreeOutOfViewTargetSystem:execute()
    for _, entity in self.filter:reverse_entities() do
        local target = self.targets:get(entity)

        if self.positions:has(target.target) then
            local view_rad = self.view_radiuses:get(entity)
            local pos = self.positions:get(entity)
            local target_pos = self.positions:get(target.target)

            local dx = target_pos.x - pos.x
            local dy = target_pos.y - pos.y
            local lensq = dx * dx + dy * dy
            if lensq > view_rad.radius * view_rad.radius then
                self.targets:del(entity)
            end
        end
    end
end

return FreeOutOfViewTargetSystem