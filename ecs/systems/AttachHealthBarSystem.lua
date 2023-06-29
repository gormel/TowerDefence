local ecstasy = require "external.ecstasy"
local constants = require "ecs.constants"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class AttachHealthBarSystem : ecstasy.System
local AttachHealthBarSystem = ecstasy.System("AttachHealthBarSystem")

function AttachHealthBarSystem:init()
    self.bar_links = self.world:get_table(Components.HasHealthBar)
    self.resources = self.world:get_table(Components.Resource)
	self.parents = self.world:get_table(Components.Parent)
	self.attach_to_parents = self.world:get_table(Components.AttachToParent)
	self.bars = self.world:get_table(Components.HealthBar)

    self.filter = self.world:create_filter(Components.Health, exc(Components.HasHealthBar))
end

function AttachHealthBarSystem:execute()
    for _, entity in self.filter:reverse_entities() do
        local hp_view_entity = self.world:new_entity()
        local hp_res = self.resources:add(hp_view_entity)
        hp_res.factory_url = constants.FACTORY_URL_HP_BAR
        local hp_parent = self.parents:add(hp_view_entity)
        hp_parent.entity = entity
        local attach = self.attach_to_parents:add(hp_view_entity)
        attach.sync_angle = false
        attach.dy = 25
        self.bars:add(hp_view_entity)

        local link = self.bar_links:add(entity)
        link.entity = hp_view_entity
    end
end

return AttachHealthBarSystem