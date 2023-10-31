local ecstasy = require "external.ecstasy"
local constants = require "ecs.constants"
local mesages   = require "main.mesages"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class GameOverSystem : ecstasy.System
local GameOverSystem = ecstasy.System("GameOverSystem")

function GameOverSystem:init()
    self.destroyeds = self.world:get_table(Components.Destroyed)

    self.filter = self.world:create_filter(Components.Castle, Components.Destroyed)
end

function GameOverSystem:execute()
    for _, entity in self.filter:entities() do
        for i = 1, self.world.current_entity_id do
            self.destroyeds:get_or_add(i)
        end
        msg.post(constants.URL_MAIN, mesages.GAME_OVER)
        break
    end
end

return GameOverSystem