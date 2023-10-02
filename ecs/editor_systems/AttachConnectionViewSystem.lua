local ecstasy    = require "external.ecstasy"
local Components = require("ecs.components")
local EComponents = require("ecs.editor_components")
local constants   = require("ecs.constants")

local exc, inc   = ecstasy.exc, ecstasy.inc

---@class AttachConnectionViewSystem : ecstasy.System
local AttachConnectionViewSystem = ecstasy.System("AttachConnectionViewSystem")

function AttachConnectionViewSystem:init()
    self.attaches = self.world:get_table(EComponents.AttachConnectionView)
    self.views = self.world:get_table(EComponents.ConnectionView)
    self.resources = self.world:get_table(Components.Resource)
    self.parent_attaches = self.world:get_table(Components.AttachToParent)
    self.parents = self.world:get_table(Components.Parent)

    self.filter = self.world:create_filter(EComponents.AttachConnectionView, EComponents.Connection)
end

function AttachConnectionViewSystem:execute()
    for _, entity in self.filter:reverse_entities() do
        local line_view_entity = self.world:new_entity()
        local line_resource = self.resources:add(line_view_entity)
        line_resource.factory_url = constants.FACTORY_URL_EDITOR_CONNECTION
        local line_parent = self.parents:add(line_view_entity)
        line_parent.entity = entity
        self.parent_attaches:add(line_view_entity)
        self.views:add(line_view_entity)

        local dir_view_entity = self.world:new_entity()
        local dir_resource = self.resources:add(dir_view_entity)
        dir_resource.factory_url = constants.FACTORY_URL_EDITOR_CONNECTION_DIR
        local dir_parent = self.parents:add(dir_view_entity)
        dir_parent.entity = entity
        local dir_attach = self.parent_attaches:add(dir_view_entity)
        dir_attach.da = math.pi / 2

        self.attaches:del(entity)
    end
end

return AttachConnectionViewSystem
