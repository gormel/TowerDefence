local ecstasy = require "external.ecstasy"
local Components = require("ecs.components")

local DestroySystem = ecstasy.System("DestroySystem")

function DestroySystem:init()
	self.destroyed_components = self.world:get_table(Components.Destroyed)
end

function DestroySystem:execute(Time)
	for _, entity in self.destroyed_components:reverse_entities() do
		self.world:del_entity(entity)
	end
end

return DestroySystem