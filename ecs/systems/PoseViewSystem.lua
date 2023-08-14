local ecstasy = require "external.ecstasy"
local Components = require("ecs.components")

---@class PoseViewSystem : ecstasy.System
local PoseViewSystem = ecstasy.System("PoseViewSystem")

function PoseViewSystem:init()
	self.view_components = self.world:get_table(Components.View)
	self.position_components = self.world:get_table(Components.Position)
	self.filter = self.world:create_filter(Components.View, Components.Position)
end

function PoseViewSystem:execute(Time)
	for _, entity in self.filter:entities() do
		local view = self.view_components:get(entity)
		local pos = self.position_components:get(entity)

		go.set_position(vmath.vector3(pos.x, pos.y, pos.z), view.id)
	end
end

return PoseViewSystem