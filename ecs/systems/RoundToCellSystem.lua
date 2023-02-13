local ecstasy = require "external.ecstasy"
local Components = require("ecs.components")
local Constants = require("ecs.constants")

local RoundToCellSystem = ecstasy.System("RoundToCellSystem")

function RoundToCellSystem:init()
	self.position_components = self.world:get_table(Components.Position)
	self.filter = self.world:create_filter(Components.RoundToCell, Components.Position)
end

function RoundToCellSystem:execute(Time)
	for _, entity in self.filter:entities() do
		local pos = self.position_components:get(entity)

		pos.x = math.floor(pos.x / Constants.CELL_SIZE + 0.5) * Constants.CELL_SIZE
		pos.y = math.floor(pos.y / Constants.CELL_SIZE + 0.5) * Constants.CELL_SIZE
	end
end

return RoundToCellSystem