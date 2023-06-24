local ecstasy = require "external.ecstasy"
local Constants = require "ecs.constants"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")
local Msg = require("main.mesages")

---@class RenderSelectedTowerSystem : ecstasy.System
local RenderSelectedTowerSystem = ecstasy.System("RenderSelectedTowerSystem")

function RenderSelectedTowerSystem:init()
    self.selected_towers = self.world:get_table(Components.SelectedTowerType)
end

function RenderSelectedTowerSystem:execute()
    for _, selected_tower in self.selected_towers:components() do
        msg.post(Constants.URL_GUI, Msg.UPDATE_SELECTED_TOWER, { tower_type = selected_tower.tower_type })
    end
end

return RenderSelectedTowerSystem