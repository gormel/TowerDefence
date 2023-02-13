local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class FollowTargetSystem : ecstasy.System
local FollowTargetSystem = ecstasy.System("FollowTargetSystem")

function FollowTargetSystem:init()
    self.positions = self.world:get_table(Components.Position)
    self.velocitys = self.world:get_table(Components.Velocity)
    self.follows = self.world:get_table(Components.FollowTarget)
    self.target_reacheds = self.world:get_table(Components.TargetReached)
    self.targets = self.world:get_table(Components.Target)

    self.filter = self.world:create_filter(Components.FollowTarget, Components.Position, Components.Target)
end

function FollowTargetSystem:execute()
    for _, entity in self.filter:entities() do
        local pos = self.positions:get(entity)
        local follow = self.follows:get(entity)
        local target = self.targets:get(entity)

        if self.positions:has(target.target) then
            local target_pos = self.positions:get(target.target)
    
            local dx = target_pos.x - pos.x
            local dy = target_pos.y - pos.y
            local len = math.sqrt(dx * dx + dy * dy)

            local vel = self.velocitys:get_or_add(entity)
            if len > 1 then
                vel.x = dx / len * follow.speed
                vel.y = dy / len * follow.speed
            else
                vel.x = 0
                vel.y = 0
                local reached = self.target_reacheds:get_or_add(entity)
                reached.target = target.target
            end
        end
    end
end

return FollowTargetSystem