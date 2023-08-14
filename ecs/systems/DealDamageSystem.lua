local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class DealDamageSystem : ecstasy.System
local DealDamageSystem = ecstasy.System("DealDamageSystem")

function DealDamageSystem:init()
    self.damages = self.world:get_table(Components.Damage)
    self.deals = self.world:get_table(Components.DealDamage)
    self.healthes = self.world:get_table(Components.Health)
    self.last_sources = self.world:get_table(Components.LastDamageSource)
    self.dmg_transporters = self.world:get_table(Components.DamageTransporter)

    self.filter = self.world:create_filter(Components.DealDamage, Components.Damage)
end

function DealDamageSystem:execute()
    for _, entity in self.filter:reverse_entities() do
        local deal = self.deals:get(entity)
        local damage = self.damages:get(entity)

        for _, target_entity in ipairs(deal.target_entities) do
            if self.healthes:has(target_entity) then
                local target_health = self.healthes:get(target_entity)
                target_health.value = target_health.value - damage.value

                local dealer_entity = entity
                while self.dmg_transporters:has(dealer_entity) do
                    local transporter = self.dmg_transporters:get(dealer_entity)
                    dealer_entity = transporter.dealer_entity
                end

                local source = self.last_sources:get_or_add(target_entity)
                source.source_entity = dealer_entity
            end
        end

        self.deals:del(entity)
    end
end

return DealDamageSystem