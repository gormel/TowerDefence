local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class DestroyByHealthSystem : ecstasy.System
local DestroyByHealthSystem = ecstasy.System("DestroyByHealthSystem")

function DestroyByHealthSystem:init()
    self.healths = self.world:get_table(Components.Health)
    self.destroyeds = self.world:get_table(Components.Destroyed)
end

function DestroyByHealthSystem:execute()
    for _, entity in self.healths:entities() do
        local hp = self.healths:get(entity)
        if hp.value <= 0 then
            self.destroyeds:add(entity)
        end
    end
end

return DestroyByHealthSystem