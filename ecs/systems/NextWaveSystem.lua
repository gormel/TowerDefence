local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class NextWaveSystem : ecstasy.System
local NextWaveSystem = ecstasy.System("NextWaveSystem")

function NextWaveSystem:init()
    self.cooldowns = self.world:get_table(Components.Cooldown)

    self.spawner_filter = self.world:create_filter(Components.MonsterSpawner, Components.Cooldown)
    self.requests = self.world:get_table(Components.NextWaveRequest)
end

function NextWaveSystem:execute()
    for _, _ in self.requests:components() do
        for _, entity in self.spawner_filter:entities() do
            local cd = self.cooldowns:get(entity)
            cd.value = 0
        end
    end
end

return NextWaveSystem