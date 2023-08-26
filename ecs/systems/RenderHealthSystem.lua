local ecstasy = require "external.ecstasy"
local mesages = require "main.mesages"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class RenderHealthSystem : ecstasy.System
local RenderHealthSystem = ecstasy.System("RenderHealthSystem")

function RenderHealthSystem:init()
    self.parents = self.world:get_table(Components.Parent)
    self.views = self.world:get_table(Components.View)
    self.hp_views = self.world:get_table(Components.HealthBar)
    self.hps = self.world:get_table(Components.Health)

    self.filter = self.world:create_filter(Components.HealthBar, Components.View, Components.Parent)
end

function RenderHealthSystem:execute()
    for _, entity in self.filter:entities() do
        local hp_view = self.hp_views:get(entity)
        local parent = self.parents:get(entity)
        local hp = self.hps:safe_get(parent.entity)
        if hp ~= nil and hp_view.health_value ~= hp.value then
            local view = self.views:get(entity)
            hp_view.health_value = hp.value
            msg.post(msg.url(nil, view.id, "hp_bar"), mesages.SET_HEALTH, { hp_value = hp.value / hp.max_value })
        end
    end
end

return RenderHealthSystem