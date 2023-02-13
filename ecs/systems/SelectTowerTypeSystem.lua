local ecstasy = require "external.ecstasy"
local Components = require("ecs.components")

local SelectTowerTypeSystem = ecstasy.System("SelectTowerTypeSystem")

function SelectTowerTypeSystem:init()
	self.req_components = self.world:get_table(Components.SelectTowerTypeRequest)
	self.selecter_tower_type_components = self.world:get_table(Components.SelectedTowerType)
end

function SelectTowerTypeSystem:execute(Time)
	for _, entity in self.req_components:entities() do
		local req = self.req_components:get(entity)

		for _, selected in self.selecter_tower_type_components:components() do
			selected.tower_type = req.tower_type
		end
	end
end

return SelectTowerTypeSystem