local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class DestroyByHealthSystem : ecstasy.System
local DestroyByHealthSystem = ecstasy.System("DestroyByHealthSystem")

function DestroyByHealthSystem:init()
    self.healths = self.world:get_table(Components.Health)
    self.sources = self.world:get_table(Components.LastDamageSource)
    self.kill_counters = self.world:get_table(Components.KillCounter)
    self.destroyeds = self.world:get_table(Components.Destroyed)
end

function DestroyByHealthSystem:execute()
    for _, entity in self.healths:entities() do
        local hp = self.healths:get(entity)
        if hp.value <= 0 then
            self.destroyeds:add(entity)
            local source = self.sources:safe_get(entity)
            if source ~= nil and self.kill_counters:has(source.source_entity) then
                local counter = self.kill_counters:get(source.source_entity)
                counter.value = counter.value + 1
            end
        end
    end
end

return DestroyByHealthSystem