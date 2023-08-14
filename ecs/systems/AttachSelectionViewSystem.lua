local ecstasy = require "external.ecstasy"
local constants = require "ecs.constants"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class AttachSelectionViewSystem : ecstasy.System
local AttachSelectionViewSystem = ecstasy.System("AttachSelectionViewSystem")

function AttachSelectionViewSystem:init()
    self.links = self.world:get_table(Components.HasSelectionView)
    self.resources = self.world:get_table(Components.Resource)
	self.parents = self.world:get_table(Components.Parent)
	self.attach_to_parents = self.world:get_table(Components.AttachToParent)
	self.views = self.world:get_table(Components.SelectionView)
	self.destroyeds = self.world:get_table(Components.Destroyed)

    self.add_filter = self.world:create_filter(Components.Selected, exc(Components.HasSelectionView))
    self.del_filter = self.world:create_filter(Components.HasSelectionView, exc(Components.Selected))
end

function AttachSelectionViewSystem:execute()
    for _, entity in self.add_filter:reverse_entities() do
        local view_entity = self.world:new_entity()
        local res = self.resources:add(view_entity)
        res.factory_url = constants.FACTORY_URL_SELECTION
        local parent = self.parents:add(view_entity)
        parent.entity = entity
        local attach = self.attach_to_parents:add(view_entity)
        attach.sync_angle = false
        attach.dz = -0.1
        self.views:add(view_entity)

        local link = self.links:add(entity)
        link.view_entity = view_entity
    end

    for _, entity in self.del_filter:reverse_entities() do
        local link = self.links:get(entity)
        self.destroyeds:add(link.view_entity)

        self.links:del(entity)
    end
end

return AttachSelectionViewSystem