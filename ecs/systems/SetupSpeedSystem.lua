local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class SetupSpeedSystem : ecstasy.System
local SetupSpeedSystem = ecstasy.System("SetupSpeedSystem")

function SetupSpeedSystem:init()
    self.speeds = self.world:get_table(Components.Speed)
end

function SetupSpeedSystem:execute()
    for _, speed in self.speeds:components() do
        if speed.initial_value == nil then
            speed.initial_value = speed.value
        end

        speed.value = speed.initial_value
    end
end

return SetupSpeedSystem