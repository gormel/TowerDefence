local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class DestroyOnCastleReachedSystem : ecstasy.System
local DestroyOnCastleReachedSystem = ecstasy.System("DestroyOnCastleReachedSystem")

function DestroyOnCastleReachedSystem:init()
    self.destroyeds = self.world:get_table(Components.Destroyed)
    self.castles = self.world:get_table(Components.Castle)
    self.reacheds = self.world:get_table(Components.TargetReached)

    self.filter = self.world:create_filter(Components.DestroyOnCastleReached, Components.TargetReached)
    
end

function DestroyOnCastleReachedSystem:execute()
    for _, entity in self.filter:entities() do
        local reached = self.reacheds:get(entity)
        if self.castles:has(reached.target) then
            self.destroyeds:get_or_add(entity)
        end
    end
end

return DestroyOnCastleReachedSystem