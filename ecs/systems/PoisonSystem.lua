local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class PoisonSystem : ecstasy.System
local PoisonSystem = ecstasy.System("PoisonSystem")

function PoisonSystem:init()
    self.healths = self.world:get_table(Components.Health)
    self.poisoneds = self.world:get_table(Components.Poisoned)

    self.filter = self.world:create_filter(Components.Poisoned, Components.Health)
end

function PoisonSystem:execute(dt)
    for _, entity in self.filter:reverse_entities() do
        local poisoned = self.poisoneds:get(entity)
        local health = self.healths:get(entity)

        poisoned.cooldown = poisoned.cooldown - dt
        if poisoned.cooldown <= 0 then
            poisoned.cooldown = poisoned.tick_time
            poisoned.tick_count = poisoned.tick_count - 1
            health.value = health.value - poisoned.tick_damage
        end

        if poisoned.tick_count <= 0 then
            self.poisoneds:del(entity)
        end
    end
end

return PoisonSystem