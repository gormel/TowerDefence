local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")
local const = require "ecs.constants"

---@class SelectTowerSystem : ecstasy.System
local SelectTowerSystem = ecstasy.System("SelectTowerSystem")

function SelectTowerSystem:init()
    self.pointer_inputs = self.world:get_table(Components.PointerInput)
    self.position_components = self.world:get_table(Components.Position)
    self.selecteds = self.world:get_table(Components.Selected)

    self.filter = self.world:create_filter(Components.MouseDownInput, Components.PointerInput)
    self.selected_tower_filter = self.world:create_filter(Components.Tower, Components.Selected)
    self.tower_filter = self.world:create_filter(Components.Tower, Components.Position, exc(Components.Selected))
end

function SelectTowerSystem:execute()
    for _, entity in self.filter:entities() do
        local pointer = self.pointer_inputs:get(entity)
        
		for _, tower_entity in self.tower_filter:entities() do
			local tower_pos = self.position_components:get(tower_entity)
			local dist_x = pointer.x - tower_pos.x
			local dist_y = pointer.y - tower_pos.y
			local dist = dist_x * dist_x + dist_y * dist_y
			if dist < const.CELL_SIZE * const.CELL_SIZE / 4 then
                for _, selected_entity in self.selected_tower_filter:reverse_entities() do
                    self.selecteds:del(selected_entity)
                end

                self.selecteds:add(tower_entity)
				break
			end
		end
    end
end

return SelectTowerSystem