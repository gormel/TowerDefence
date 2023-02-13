local ecstasy = require "external.ecstasy"
local exc, added, removed = ecstasy.exc, ecstasy.added, ecstasy.removed
local Components = require("ecs.components")

local InitViewSystem = ecstasy.System("InitViewSystem")

function InitViewSystem:init()
	self.resource_components = self.world:get_table(Components.Resource)
	self.position_components = self.world:get_table(Components.Position)
	self.view_components = self.world:get_table(Components.View)

	self.resource_filter = self.world:create_filter(Components.Resource, Components.Position, exc(Components.View))
end

function InitViewSystem:execute()
	for _, entity in self.resource_filter:entities() do
		local pos = self.position_components:get(entity)
		local factory_url = self.resource_components:get(entity).factory_url
		
		local view_id = factory.create(factory_url, vmath.vector3(pos.x, pos.y, 0))
		local view = self.view_components:add(entity)
		view.id = view_id
	end
end

return InitViewSystem