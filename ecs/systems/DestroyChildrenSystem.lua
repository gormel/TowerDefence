local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class DestroyChildrenSystem : ecstasy.System
local DestroyChildrenSystem = ecstasy.System("DestroyChildrenSystem")

function DestroyChildrenSystem:init()
    self.destroyeds = self.world:get_table(Components.Destroyed)
    self.parents = self.world:get_table(Components.Parent)

    self.filter = self.world:create_filter(Components.Parent, exc(Components.Destroyed))
end

function DestroyChildrenSystem:execute()
    local any_changed = true
    while any_changed do
        any_changed = false
        for _, entity in self.filter:entities() do
            local parent = self.parents:get(entity)
            if self.destroyeds:has(parent.entity) then
                any_changed = true
                self.destroyeds:add(entity)
            end
        end
    end
end

return DestroyChildrenSystem