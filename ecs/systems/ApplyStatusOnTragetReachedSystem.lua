local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class ApplyStatusOnTargetReachedSystem : ecstasy.System
local ApplyStatusOnTargetReachedSystem = ecstasy.System("ApplyStatusOnTargetReachedSystem")

function ApplyStatusOnTargetReachedSystem:init()
    self.applys = self.world:get_table(Components.ApplyStatus)
    self.triggers = self.world:get_table(Components.ApplyStatusToTargetOnTargetReached)
    self.reacheds = self.world:get_table(Components.TargetReached)
    
    self.filter = self.world:create_filter(Components.ApplyStatusToTargetOnTargetReached, Components.TargetReached)
end

function ApplyStatusOnTargetReachedSystem:execute()
    for _, entity in self.filter:entities() do
        local trigger = self.triggers:get(entity)
        local reached = self.reacheds:get(entity)

        local apply = self.applys:get_or_add(reached.target)
        for _, status in ipairs(trigger.status) do
            table.insert(apply.status, status)
        end
    end
end

return ApplyStatusOnTargetReachedSystem