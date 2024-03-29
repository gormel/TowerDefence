local ecstasy = require "external.ecstasy"
local setup   = require "ecs.setup"
local const = require "ecs.constants"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class ShootSystem : ecstasy.System
---@field factory_url string
local ShootSystem = ecstasy.System("ShootSystem")

function ShootSystem:init()
    self.targets = self.world:get_table(Components.Target)
    self.healths = self.world:get_table(Components.Health)
    self.cooldowns = self.world:get_table(Components.Cooldown)
    self.damages = self.world:get_table(Components.Damage)
    self.follow_targets = self.world:get_table(Components.FollowTarget)
    self.destroy_on_target_reacheds = self.world:get_table(Components.DestroyOnTargetReached)
    self.deal_damage_on_target_reacheds = self.world:get_table(Components.DealDamageOnTargetReached)
    self.parent_components = self.world:get_table(Components.Parent)
    self.attach_to_parent_components = self.world:get_table(Components.AttachToParent)
    self.resource_components = self.world:get_table(Components.Resource)
    self.positions = self.world:get_table(Components.Position)
    self.destroy_on_no_targets = self.world:get_table(Components.DestroyOnNoTarget)
    self.towers = self.world:get_table(Components.Tower)
    self.status_applys = self.world:get_table(Components.ApplyStatusToTargetOnTargetReached)
    self.speeds = self.world:get_table(Components.Speed)
    self.transporters = self.world:get_table(Components.DamageTransporter)

    self.filter = self.world:create_filter(Components.Tower, Components.Target, Components.Damage, Components.Position)
end

function ShootSystem:execute()
    for _, entity in self.filter:entities() do
        local target = self.targets:get(entity)
        if self.healths:has(target.target) then
            local cooldown = self.cooldowns:get_or_add(entity)
            if cooldown.value <= 0 then
                cooldown.value = const.SHOOT_DELAY

                local damage = self.damages:get(entity)
                local pos = self.positions:get(entity)
                local tower = self.towers:get(entity)

                local bullet_entity = self.world:new_entity()
                local bullet_transporter = self.transporters:add(bullet_entity)
                bullet_transporter.dealer_entity = entity
                local bullet_target = self.targets:add(bullet_entity)
                bullet_target.target = target.target
                local bullet_damage = self.damages:add(bullet_entity)
                bullet_damage.value = damage.value
                self.follow_targets:add(bullet_entity)
                local speed = self.speeds:add(bullet_entity)
                speed.value = setup.Towers[tower.tower_type].bullet_speed
                self.destroy_on_target_reacheds:add(bullet_entity)
                self.deal_damage_on_target_reacheds:add(bullet_entity)
                self.destroy_on_no_targets:add(bullet_entity)
                local bullet_pos = self.positions:add(bullet_entity)
                bullet_pos.x = pos.x
                bullet_pos.y = pos.y
                if setup.Towers[tower.tower_type].apply_status ~= nil then
                    local bullet_apply_status = self.status_applys:add(bullet_entity)
                    bullet_apply_status.source_entity = entity
                    for _, status in ipairs(setup.Towers[tower.tower_type].apply_status) do
                        table.insert(bullet_apply_status.status, status)
                    end
                end

                local bullet_view_entity = self.world:new_entity()
                local resource = self.resource_components:add(bullet_view_entity)
                resource.factory_url = setup.Towers[tower.tower_type].bullet_factory_url
                local parent = self.parent_components:add(bullet_view_entity)
                parent.entity = bullet_entity
                self.attach_to_parent_components:add(bullet_view_entity)
            end
        end
    end
end

return ShootSystem