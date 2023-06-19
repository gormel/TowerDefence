local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class BlockedSystem : ecstasy.System
local BlockedSystem = ecstasy.System("BlockedSystem")

function BlockedSystem:init()
    self.blockers = self.world:get_table(Components.Blocker)

    self.blockeds = self.world:get_table(Components.Blocked)
end

function BlockedSystem:execute()
end

return BlockedSystem