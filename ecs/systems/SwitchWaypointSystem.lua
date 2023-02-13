local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class SwitchWaypointSystem : ecstasy.System
local SwitchWaypointSystem = ecstasy.System("SwitchWaypointSystem")

function SwitchWaypointSystem:init()
    self.targets = self.world:get_table(Components.Target)
    self.waypoints = self.world:get_table(Components.Waypoint)

    self.filter = self.world:create_filter(Components.TargetReached, Components.Target)
end

function SwitchWaypointSystem:execute()
    for _, entity in self.filter:entities() do
        local target = self.targets:get(entity)
        if self.waypoints:has(target.target) then
            local target_waypoint = self.waypoints:get(target.target)
            if target_waypoint.next ~= nil then
                target.target = target_waypoint.next
            else
                self.targets:del(entity)
            end
        end
    end
end

return SwitchWaypointSystem