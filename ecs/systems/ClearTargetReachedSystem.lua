local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class ClearTargetReachedSystem : ecstasy.System
local ClearTargetReachedSystem = ecstasy.System("ClearTargetReachedSystem")

function ClearTargetReachedSystem:init()    
    self.target_reacheds = self.world:get_table(Components.TargetReached)

    self.filter = self.world:create_filter(Components.TargetReached)
end

function ClearTargetReachedSystem:execute()
    for _, entity in self.filter:reverse_entities() do
        self.target_reacheds:del(entity)
    end
end

return ClearTargetReachedSystem