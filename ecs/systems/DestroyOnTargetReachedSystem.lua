local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class DestroyOnTargetReachedSystem : ecstasy.System
local DestroyOnTargetReachedSystem = ecstasy.System("DestroyOnTargetReachedSystem")

function DestroyOnTargetReachedSystem:init()
    self.destroyeds = self.world:get_table(Components.Destroyed)

    self.filter = self.world:create_filter(Components.DestroyOnTargetReached, Components.TargetReached)
end

function DestroyOnTargetReachedSystem:execute()
    for _, entity in self.filter:entities() do
        self.destroyeds:get_or_add(entity)
    end
end

return DestroyOnTargetReachedSystem