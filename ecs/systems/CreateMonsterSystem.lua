local ecstasy = require "external.ecstasy"
local setup   = require "ecs.setup"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class CreateMonsterSystem : ecstasy.System
---@field factory_url string
local CreateMonsterSystem = ecstasy.System("CreateMonsterSystem")

function CreateMonsterSystem:init()
    self.requests = self.world:get_table(Components.MonsterCreateRequest)
    self.cooldowns = self.world:get_table(Components.Cooldown)
    self.destroyeds = self.world:get_table(Components.Destroyed)
    self.positions = self.world:get_table(Components.Position)
    self.healths = self.world:get_table(Components.Health)
    self.resources = self.world:get_table(Components.Resource)
    self.monsters = self.world:get_table(Components.Monster)
    self.targets = self.world:get_table(Components.Target)
    self.follow_targets = self.world:get_table(Components.FollowTarget)
    self.rotate_to_targets = self.world:get_table(Components.RotateToTarget)
	self.parents = self.world:get_table(Components.Parent)
	self.attach_to_parents = self.world:get_table(Components.AttachToParent)
    self.damages = self.world:get_table(Components.Damage)
    self.deal_damage_on_target_reacheds = self.world:get_table(Components.DealDamageOnTargetReached)
    self.rewards = self.world:get_table(Components.Reward)
    self.destroy_monsters = self.world:get_table(Components.DestroyOnCastleReached)

    self.filter = self.world:create_filter(Components.MonsterCreateRequest, Components.Position)
end

function CreateMonsterSystem:execute()
    for _, entity in self.filter:entities() do
        local cooldown = self.cooldowns:get_or_add(entity)
        if cooldown.value <= 0 then
            self.destroyeds:get_or_add(entity)
            local request = self.requests:get(entity)
            local position = self.positions:get(entity)

            local monster_entity = self.world:new_entity()
            local monster_pos = self.positions:add(monster_entity)
            monster_pos.x = position.x
            monster_pos.y = position.y
            local health = self.healths:add(monster_entity)
            health.value = request.hp
            self.monsters:add(monster_entity)
            local target = self.targets:add(monster_entity)
            target.target = request.initial_waypoint
            local follow_target = self.follow_targets:add(monster_entity)
            follow_target.speed = request.speed
            self.rotate_to_targets:add(monster_entity)
            local damage = self.damages:add(monster_entity)
            damage.value = request.damage
            self.deal_damage_on_target_reacheds:add(monster_entity)
            local reward = self.rewards:add(monster_entity)
            reward.value = request.reward
            self.destroy_monsters:add(monster_entity)

            local monster_view_entity = self.world:new_entity()
            local monster_res = self.resources:add(monster_view_entity)
            monster_res.factory_url = setup.MonsterSpawnerSetup.monster_factory_url
            local parent = self.parents:add(monster_view_entity)
            parent.entity = monster_entity
            self.attach_to_parents:add(monster_view_entity)
        end
    end
end

return CreateMonsterSystem