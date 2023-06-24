local ecstasy = require "external.ecstasy"
local Constants = require "ecs.constants"
local mesages = require "main.mesages"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class SpawnMonsterSystem : ecstasy.System
local SpawnMonsterSystem = ecstasy.System("SpawnMonsterSystem")

function SpawnMonsterSystem:init()
    self.spawners = self.world:get_table(Components.MonsterSpawner)
    self.positions = self.world:get_table(Components.Position)
    self.wave_numbers = self.world:get_table(Components.WaveNumber)
    self.cooldowns = self.world:get_table(Components.Cooldown)
    self.requests = self.world:get_table(Components.MonsterCreateRequest)
    self.blockeds = self.world:get_table(Components.Blocked)
    self.blockers = self.world:get_table(Components.Blocker)

    self.filter = self.world:create_filter(Components.MonsterSpawner, Components.Position, Components.Cooldown)
end

function SpawnMonsterSystem:execute()
    for _, entity in self.filter:entities() do
        local cooldown = self.cooldowns:get(entity)
        if cooldown.value <= 0 then
            local setup = self.spawners:get(entity)
            local pos = self.positions:get(entity)

            local blocked = self.blockeds:add(entity)
            for i = 1, math.floor(setup.setup.wave_size * math.pow(setup.setup.wave_size_progression, setup.wave)), 1 do
                local req_entity = self.world:new_entity()
                local req_cd = self.cooldowns:add(req_entity)
                req_cd.value = (i - 1) * setup.setup.monster_interval
                local req = self.requests:add(req_entity)
                req.hp = setup.setup.monster_hp * math.pow(setup.setup.monster_hp_progression, setup.wave)
                req.initial_waypoint = entity
                req.reward = math.floor(setup.setup.monster_reward * math.pow(setup.setup.monster_reward_progression, setup.wave))
                req.damage = setup.setup.monster_damage_to_castle
                req.speed = setup.setup.speed
                req.monster_entity = self.world:new_entity()
                local req_pos = self.positions:add(req_entity)
                req_pos.x = pos.x
                req_pos.y = pos.y

                self.blockers:add(req.monster_entity)
                table.insert(blocked.blocker_entities, req.monster_entity)
            end

            msg.post(Constants.URL_GUI, mesages.UPDATE_IDLE_STATE, { state = false })
            self.cooldowns:del(entity)
            setup.wave = setup.wave + 1
        end
    end
end

return SpawnMonsterSystem