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
    for _, entity in self.blockeds:reverse_entities() do
        local blocked = self.blockeds:get(entity)
        for i = #blocked.blocker_entities, 1, -1 do
            local blocker_entity = blocked.blocker_entities[i]
            if not self.blockers:has(blocker_entity) then
                table.remove(blocked.blocker_entities, i)
            end
        end

        if #blocked.blocker_entities < 1 then
            self.blockeds:del(entity)
        end
    end
end

return BlockedSystem