local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class DealDamageOnTargetReachedSystem : ecstasy.System
local DealDamageOnTargetReachedSystem = ecstasy.System("DealDamageOnTargetReachedSystem")

function DealDamageOnTargetReachedSystem:init()
    self.target_reacheds = self.world:get_table(Components.TargetReached)
    self.damages = self.world:get_table(Components.Damage)
    self.healthes = self.world:get_table(Components.Health)

    self.filter = self.world:create_filter(Components.DealDamageOnTargetReached, Components.TargetReached, Components.Damage)
end

function DealDamageOnTargetReachedSystem:execute()
    for _, entity in self.filter:entities() do
        local reached_target = self.target_reacheds:get(entity)
        if self.healthes:has(reached_target.target) then
            local damage = self.damages:get(entity)
            local target_health = self.healthes:get(reached_target.target)
            target_health.value = target_health.value - damage.value
        end
    end
end

return DealDamageOnTargetReachedSystem