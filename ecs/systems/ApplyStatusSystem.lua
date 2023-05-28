local ecstasy = require "external.ecstasy"
local setup   = require "ecs.setup"
local constants = require "ecs.constants"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class ApplyStatusSystem : ecstasy.System
local ApplyStatusSystem = ecstasy.System("ApplyStatusSystem")

function ApplyStatusSystem:init()
    self.frozens = self.world:get_table(Components.Frozen)
    self.poisoneds = self.world:get_table(Components.Poisoned)

    self.applys = self.world:get_table(Components.ApplyStatus)
end

function ApplyStatusSystem:execute()
    for _, entity in self.applys:reverse_entities() do
        local apply = self.applys:get(entity)

        for _, status in ipairs(apply.status) do
            local status_setup = setup.Statuses[status]
            if status_setup.type == constants.STATUS_TYPE_FROZEN then
                local frozen = self.frozens:get_or_add(entity)
                frozen.cooldown = status_setup.duration
                frozen.power = status_setup.force
            elseif status_setup.type == constants.STATUS_TYPE_POISONED then
                local poisoned = self.poisoneds:get_or_add(entity)
                poisoned.cooldown = status_setup.tick_time
                poisoned.tick_time = status_setup.tick_time
                poisoned.tick_count =  status_setup.tick_count
                poisoned.tick_damage = status_setup.tick_damage
            end
        end

        self.applys:del(entity)
    end
end

return ApplyStatusSystem