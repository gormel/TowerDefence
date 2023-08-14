local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class PoisonSystem : ecstasy.System
local PoisonSystem = ecstasy.System("PoisonSystem")

function PoisonSystem:init()
    self.poisoneds = self.world:get_table(Components.Poisoned)
    self.deals = self.world:get_table(Components.DealDamage)
    self.transporters = self.world:get_table(Components.DamageTransporter)
    self.destroyeds = self.world:get_table(Components.Destroyed)
    self.damages = self.world:get_table(Components.Damage)
    self.dealers = self.world:get_table(Components.PoisonDamageDealer)

    self.filter = self.world:create_filter(Components.Poisoned, Components.Health)
    self.dealers_filter = self.world:create_filter(Components.PoisonDamageDealer, exc(Components.Destroyed))
end

function PoisonSystem:execute(dt)
    for _, entity in self.dealers_filter:reverse_entities() do
        self.destroyeds:add(entity)
    end

    for _, entity in self.filter:reverse_entities() do
        local poisoned = self.poisoneds:get(entity)

        poisoned.cooldown = poisoned.cooldown - dt
        if poisoned.cooldown <= 0 then
            local dealer_entity = self.world:new_entity()
            local deal = self.deals:add(dealer_entity)
            table.insert(deal.target_entities, entity)
            local transporter = self.transporters:add(dealer_entity)
            transporter.dealer_entity = poisoned.source_entity
            self.dealers:add(dealer_entity)
            local damage = self.damages:add(dealer_entity)
            damage.value = poisoned.tick_damage

            poisoned.cooldown = poisoned.tick_time
            poisoned.tick_count = poisoned.tick_count - 1
        end

        if poisoned.tick_count <= 0 then
            self.poisoneds:del(entity)
        end
    end
end

return PoisonSystem