local ecstasy = require "external.ecstasy"
local constants = require "ecs.constants"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")
local EComponents = require("ecs.editor_components")

---@class SetCastleSystem : ecstasy.System
local SetCastleSystem = ecstasy.System("SetCastleSystem")

function SetCastleSystem:init()
    self.destroyeds = self.world:get_table(Components.Destroyed)
    self.castles = self.world:get_table(Components.Castle)
    self.pointers = self.world:get_table(Components.PointerInput)
    self.positions = self.world:get_table(Components.Position)
	self.cell_rounds = self.world:get_table(Components.RoundToCell)

    self.mode_filter = self.world:create_filter(EComponents.CastleEditorMode)
	self.filter = self.world:create_filter(Components.MouseDownInput, Components.PointerInput)
end

function SetCastleSystem:execute()
    for _, entity in self.filter:entities() do
        for _, _ in self.mode_filter:entities() do
            for _, castle_entity in self.castles:entities() do
                self.destroyeds:get_or_add(castle_entity)
            end

            local pointer = self.pointers:get(entity)

            local castle_entity = self.world:new_entity()
            self.castles:add(castle_entity)
            self.cell_rounds:add(castle_entity)
            local pos = self.positions:add(castle_entity)
            pos.x = pointer.x
            pos.y = pointer.y
            
            local view_entity = self.world:new_entity()
            local vew_resource = self.world:add_component(Components.Resource, view_entity)
            vew_resource.factory_url = constants.FACTORY_URL_EDITOR_CASTLE
            local view_parent = self.world:add_component(Components.Parent, view_entity)
            view_parent.entity = castle_entity
            self.world:add_component(Components.AttachToParent, view_entity)
        end
    end
end

return SetCastleSystem