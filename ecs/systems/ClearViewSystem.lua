local ecstasy = require "external.ecstasy"
local Components = require("ecs.components")

local ClearViewSystem = ecstasy.System("ClearViewSystem")

function ClearViewSystem:init()
	self.view_components = self.world:get_table(Components.View)
	self.destroy_components = self.world:get_table(Components.Destroyed)
	self.views_filter = self.world:create_filter(Components.View, Components.Destroyed)
end

function ClearViewSystem:execute()
	for _, entity in self.views_filter:entities() do
		local view = self.view_components:get(entity)
		go.delete(view.id)
	end
end

return ClearViewSystem