local ecstasy = require "external.ecstasy"
local setup   = require "ecs.setup"
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
            if status == "Frozen" then
                local frozen = self.frozens:get_or_add(entity)
                frozen.cooldown = setup.Statuses[status].duration
                frozen.power = setup.Statuses[status].force
            elseif status == "Poisoned" then
                self.poisoneds:get_or_add(entity)
            end
        end

        self.applys:del(entity)
    end
end

return ApplyStatusSystem