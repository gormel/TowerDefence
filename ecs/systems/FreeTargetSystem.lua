local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class FreeTargetSystem : ecstasy.System
local FreeTargetSystem = ecstasy.System("FreeTargetSystem")

function FreeTargetSystem:init()
    self.targets = self.world:get_table(Components.Target)
    self.destroyeds = self.world:get_table(Components.Destroyed)
end

function FreeTargetSystem:execute()
    for _, entity in self.targets:reverse_entries() do
        local target = self.targets:get(entity)
        if self.destroyeds:has(target.target) then
            self.targets:del(entity)
        end
    end
end

return FreeTargetSystem