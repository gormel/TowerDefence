local ecstasy = require "external.ecstasy"
local Constants = require "ecs.constants"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")
local Msg = require("main.mesages")

---@class RenderSelectedTowerTypeSystem : ecstasy.System
local RenderSelectedTowerTypeSystem = ecstasy.System("RenderSelectedTowerTypeSystem")

function RenderSelectedTowerTypeSystem:init()
    self.selected_towers = self.world:get_table(Components.SelectedTowerType)
end

function RenderSelectedTowerTypeSystem:execute()
    for _, selected_tower in self.selected_towers:components() do
        msg.post(Constants.URL_GUI, Msg.UPDATE_SELECTED_TOWER_TYPE, { tower_type = selected_tower.tower_type })
    end
end

return RenderSelectedTowerTypeSystem