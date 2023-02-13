local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class ApplyVelocitySystem : ecstasy.System
local ApplyVelocitySystem = ecstasy.System("ApplyVelocitySystem")

function ApplyVelocitySystem:init()
    self.velocitys = self.world:get_table(Components.Velocity)
    self.positions = self.world:get_table(Components.Position)
    self.filter = self.world:create_filter(Components.Velocity, Components.Position)
end

---@param dt number
function ApplyVelocitySystem:execute(dt)
    for _, entity in self.filter:entities() do
        local velocity = self.velocitys:get(entity)
        local position = self.positions:get(entity)

        position.x = position.x + velocity.x * dt
        position.y = position.y + velocity.y * dt
    end
end

return ApplyVelocitySystem