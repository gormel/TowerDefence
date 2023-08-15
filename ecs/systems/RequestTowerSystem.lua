local ecstasy = require "external.ecstasy"
local exc, added, removed = ecstasy.exc, ecstasy.added, ecstasy.removed
local Components = require("ecs.components")
local Constants = require("ecs.constants")

---@class RequestTowerSystem : ecstasy.System
local RequestTowerSystem = ecstasy.System("RequestTowerSystem")

function RequestTowerSystem:init()
	self.mousedown_components = self.world:get_table(Components.MouseDownInput)
	self.pointer_components = self.world:get_table(Components.PointerInput)
	self.request_components = self.world:get_table(Components.TowerBuyRequest)
	self.position_components = self.world:get_table(Components.Position)
	self.tower_type_components = self.world:get_table(Components.SelectedTowerType)
	self.round_to_cell_components = self.world:get_table(Components.RoundToCell)
	
	self.filter = self.world:create_filter(Components.MouseDownInput, Components.PointerInput)
end

function RequestTowerSystem:execute()
	for _, entity in self.filter:entities() do
		local mouse_pos = self.pointer_components:get(entity)

		for _, tower_type in self.tower_type_components:components() do
			local request_entity = self.world:new_entity()
			local req = self.request_components:add(request_entity)
			req.tower_type = tower_type.tower_type
			local pos = self.position_components:add(request_entity)
			pos.x = mouse_pos.x
			pos.y = mouse_pos.y
			self.round_to_cell_components:add(request_entity)
			
			break
		end
	end
end

return RequestTowerSystem