local ecstasy = require "external.ecstasy"
local Components = require("ecs.components")
local Constants = require("ecs.constants")

local FollowPointerSystem = ecstasy.System("FollowPointerSystem")

function FollowPointerSystem:init()
	self.position_components = self.world:get_table(Components.Position)
	self.pointer_components = self.world:get_table(Components.PointerInput)
	self.follow_filter = self.world:create_filter(Components.FollowPointer, Components.Position)
	self.pointer_filter = self.world:create_filter(Components.PointerInput)
end

function FollowPointerSystem:execute(Time)
	for _, input_entity in self.pointer_filter:entities() do
		local input_pos = self.pointer_components:get(input_entity)
		for _, follow_entity in self.follow_filter:entities() do
			local pos = self.position_components:get(follow_entity)
			pos.x = input_pos.x
			pos.y = input_pos.y
		end
	end
end

return FollowPointerSystem