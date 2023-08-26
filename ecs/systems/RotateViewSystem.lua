local ecstasy = require "external.ecstasy"
local mesages = require "main.mesages"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class RotateViewSystem : ecstasy.System
local RotateViewSystem = ecstasy.System("RotateViewSystem")

function RotateViewSystem:init()
	self.view_components = self.world:get_table(Components.View)
	self.rotation_components = self.world:get_table(Components.Rotation)
	self.filter = self.world:create_filter(Components.View, Components.Rotation)
end

function RotateViewSystem:execute()
	for _, entity in self.filter:entities() do
		local view = self.view_components:get(entity)
		local rot = self.rotation_components:get(entity)

		msg.post(msg.url(nil, view.id, "rotation"), mesages.SET_ROTATION, { angle = rot.angle })
	end
end

return RotateViewSystem