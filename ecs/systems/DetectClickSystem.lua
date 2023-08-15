local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class DetectClickSystem : ecstasy.System
local DetectClickSystem = ecstasy.System("DetectClickSystem")

function DetectClickSystem:init()
    self.views = self.world:get_table(Components.View)
    self.clickeds = self.world:get_table(Components.Clicked)

    self.filter = self.world:create_filter(Components.ClickDetector, Components.View)
end

function DetectClickSystem:execute()
    for _, entity in self.clickeds:reverse_entities() do
        self.clickeds:del(entity)
    end

    for _, entity in self.filter:entities() do
        local view = self.views:get(entity)

        if go.get(msg.url(nil, view.id, "detect_click"), "clicked") == 1 then
            self.clickeds:add(entity)
            go.set(msg.url(nil, view.id, "detect_click"), "clicked", 0)
        end
    end
end

return DetectClickSystem