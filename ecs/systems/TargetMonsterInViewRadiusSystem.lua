local ecstasy = require "external.ecstasy"
local setup   = require "ecs.setup"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")
local const = require "ecs.constants"

---@class TargetMonsterInViewRadiusSystem : ecstasy.System
local TargetMonsterInViewRadiusSystem = ecstasy.System("TargetMonsterInViewRadiusSystem")

function TargetMonsterInViewRadiusSystem:init()
    self.view_radiuses = self.world:get_table(Components.ViewRadius)
    self.targets = self.world:get_table(Components.Target)
    self.positions = self.world:get_table(Components.Position)
    self.filterses = self.world:get_table(Components.TargetFilters)

    self.status_comps = {
        [const.STATUS_TYPE_FROZEN] = self.world:get_table(Components.Frozen),
        [const.STATUS_TYPE_POISONED] = self.world:get_table(Components.Poisoned),
    }

    self.monsters_filter = self.world:create_filter(Components.Monster, Components.Position)
    self.filter = self.world:create_filter(Components.TargetMonsterInViewRadius, Components.ViewRadius, Components.Position, exc(Components.Target))
    self.clear_filter = self.world:create_filter(Components.TargetMonsterInViewRadius, Components.ViewRadius, Components.Position, Components.Target, Components.TargetFilters)
end

local entities = {}

local function match(self, entity, filters)
    for _, filter in ipairs(filters) do
        local filter_cfg = setup.TargetFilters[filter]
        
        for _, status_type in ipairs(filter_cfg.exc_status_types) do
            if self.status_comps[status_type]:has(entity) then
                return not filter_cfg.no_exceptions, false
            end
        end
    end
    return true, true
end

function TargetMonsterInViewRadiusSystem:execute()
    for _, entity in self.clear_filter:reverse_entities() do
        local target = self.targets:get(entity)
        local filters = self.filterses:get(entity)
        local is_match, hi_priority = match(self, target.target, filters.filters)
        if not is_match or not hi_priority then
            self.targets:del(entity)
        end
    end

    for _, selector_entity in self.filter:entities() do
        local selector_pos = self.positions:get(selector_entity)
        local selector_view_radius = self.view_radiuses:get(selector_entity)

        while #entities > 0 do
            table.remove(entities)
        end

        for _, monster_entity in self.monsters_filter:entities() do
            local monster_pos = self.positions:get(monster_entity)

            local dx = monster_pos.x - selector_pos.x
            local dy = monster_pos.y - selector_pos.y
            local lensq = dx * dx + dy * dy

            if lensq <= selector_view_radius.radius * selector_view_radius.radius then
                local filters = self.filterses:safe_get(selector_entity)
                if filters ~= nil then
                    local is_match, hi_priority = match(self, monster_entity, filters.filters)
                    if is_match then
                        if hi_priority then
                            table.insert(entities, 1, monster_entity)
                        else
                            table.insert(entities, monster_entity)
                        end
                    end
                else
                    table.insert(entities, 1, monster_entity)
                end
            end
        end

        if #entities > 0 then
            local target = self.targets:add(selector_entity)
            target.target = entities[1]
        end
    end
end

return TargetMonsterInViewRadiusSystem