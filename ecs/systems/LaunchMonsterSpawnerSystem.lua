local ecstasy = require "external.ecstasy"
local constants = require "ecs.constants"
local mesages   = require "main.mesages"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class LaunchMonsterSpawnerSystem : ecstasy.System
local LaunchMonsterSpawnerSystem = ecstasy.System("LaunchMonsterSpawnerSystem")

function LaunchMonsterSpawnerSystem:init()
    self.spawners = self.world:get_table(Components.MonsterSpawner)
    self.cooldowns = self.world:get_table(Components.Cooldown)

    self.filter = self.world:create_filter(Components.MonsterSpawner, exc(Components.Blocked), exc(Components.Cooldown))
end

function LaunchMonsterSpawnerSystem:execute()
    for _, entity in self.filter:reverse_entities() do
        local setup = self.spawners:get(entity)
        local cd = self.cooldowns:add(entity)
        cd.value = setup.setup.wave_interval
        
        msg.post(constants.URL_GUI, mesages.UPDATE_IDLE_STATE, { state = true })
    end
end

return LaunchMonsterSpawnerSystem