local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class RewardSystem : ecstasy.System
local RewardSystem = ecstasy.System("RewardSystem")

function RewardSystem:init()
    self.rewards = self.world:get_table(Components.Reward)
    self.moneys = self.world:get_table(Components.Money)

    self.filter = self.world:create_filter(Components.Reward, Components.Destroyed)
end

function RewardSystem:execute()
    for _, entity in self.filter:entities() do
        local reward = self.rewards:get(entity)
        for _, money in self.moneys:components() do
            money.value = money.value + reward.value
        end
    end
end

return RewardSystem