local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class FrozenSystem : ecstasy.System
local FrozenSystem = ecstasy.System("FrozenSystem")

function FrozenSystem:init()
    self.speeds = self.world:get_table(Components.Speed)
    self.frozens = self.world:get_table(Components.Frozen)

    self.filter = self.world:create_filter(Components.Frozen)
end

function FrozenSystem:execute(dt)
    for _, entity in self.filter:reverse_entities() do
        local frozen = self.frozens:get(entity)
        frozen.cooldown = frozen.cooldown - dt
        local speed = self.speeds:safe_get(entity)
        if speed ~= nil then
            speed.value = speed.initial_value * frozen.power
        end

        if frozen.cooldown <= 0 then
            self.frozens:del(entity)
        end
    end
end

return FrozenSystem