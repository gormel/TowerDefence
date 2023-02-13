local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class DestroyOnNoTargetSystem : ecstasy.System
local DestroyOnNoTargetSystem = ecstasy.System("DestroyOnNoTargetSystem")

function DestroyOnNoTargetSystem:init()
    self.destroyeds = self.world:get_table(Components.Destroyed)
    self.targets = self.world:get_table(Components.Target)

    self.filter = self.world:create_filter(Components.DestroyOnNoTarget, Components.Target)
end

function DestroyOnNoTargetSystem:execute()
    for _, entity in self.filter:entities() do
        local target = self.targets:get(entity)
        if self.destroyeds:has(target.target) then
            self.destroyeds:add(entity)
        end
    end
end

return DestroyOnNoTargetSystem