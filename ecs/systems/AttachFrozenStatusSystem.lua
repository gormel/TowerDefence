local ecstasy = require "external.ecstasy"
local constants = require "ecs.constants"
local setup     = require "ecs.setup"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class AttachFrozenStatusSystem : ecstasy.System
local AttachFrozenStatusSystem = ecstasy.System("AttachFrozenStatusSystem")

function AttachFrozenStatusSystem:init()
    self.status_links = self.world:get_table(Components.HasFrozenStatus)
    self.resources = self.world:get_table(Components.Resource)
	self.parents = self.world:get_table(Components.Parent)
	self.attach_to_parents = self.world:get_table(Components.AttachToParent)
	self.statuses = self.world:get_table(Components.FrozenStatus)
	self.frozens = self.world:get_table(Components.Frozen)
	self.destroyeds = self.world:get_table(Components.Destroyed)
    
    self.add_filter = self.world:create_filter(Components.Frozen, exc(Components.HasFrozenStatus))
    self.del_filter = self.world:create_filter(Components.HasFrozenStatus, exc(Components.Frozen))
end

function AttachFrozenStatusSystem:execute()
    for _, entity in self.add_filter:reverse_entities() do
        local frozen = self.frozens:get(entity)
        local status_cfg = setup.Statuses[frozen.status_id]

        local view_entity = self.world:new_entity()
        local res = self.resources:add(view_entity)
        res.factory_url = status_cfg.factory_url
        local parent = self.parents:add(view_entity)
        parent.entity = entity
        local attach = self.attach_to_parents:add(view_entity)
        attach.sync_angle = false
        self.statuses:add(view_entity)

        local link = self.status_links:add(entity)
        link.entity = view_entity
    end

    for _, entity in self.del_filter:reverse_entities() do
        local status_link = self.status_links:get(entity)
        
        self.destroyeds:add(status_link.entity)
        self.status_links:del(entity)
    end
end

return AttachFrozenStatusSystem