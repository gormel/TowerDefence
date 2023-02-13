local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class CooldownSystem : ecstasy.System
local CooldownSystem = ecstasy.System("CooldownSystem")

function CooldownSystem:init()
    self.cooldowns = self.world:get_table(Components.Cooldown)
end

---@argument dt number
function CooldownSystem:execute(dt)
    for _, cooldown in self.cooldowns:components() do
        cooldown.value = cooldown.value - dt
    end
end

return CooldownSystem