local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class TargetMonsterInViewRadiusSystem : ecstasy.System
local TargetMonsterInViewRadiusSystem = ecstasy.System("TargetMonsterInViewRadiusSystem")

function TargetMonsterInViewRadiusSystem:init()
    self.view_radiuses = self.world:get_table(Components.ViewRadius)
    self.targets = self.world:get_table(Components.Target)
    self.positions = self.world:get_table(Components.Position)

    self.monsters_filter = self.world:create_filter(Components.Monster, Components.Position)
    self.filter = self.world:create_filter(Components.TargetMonsterInViewRadius, Components.ViewRadius, Components.Position, exc(Components.Target))
end

function TargetMonsterInViewRadiusSystem:execute()
    for _, selector_entity in self.filter:entities() do
        local selector_pos = self.positions:get(selector_entity)
        local selector_view_radius = self.view_radiuses:get(selector_entity)

        for _, monster_entity in self.monsters_filter:entities() do
            local monster_pos = self.positions:get(monster_entity)

            local dx = monster_pos.x - selector_pos.x
            local dy = monster_pos.y - selector_pos.y
            local lensq = dx * dx + dy * dy

            if lensq <= selector_view_radius.radius * selector_view_radius.radius then
                local target = self.targets:add(selector_entity)
                target.target = monster_entity
                break
            end
        end
    end
end

return TargetMonsterInViewRadiusSystem