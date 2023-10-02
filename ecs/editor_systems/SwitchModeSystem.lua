local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")
local EComponents = require "ecs.editor_components"

---@class SwitchModeSystem : ecstasy.System
local SwitchModeSystem = ecstasy.System("SwitchModeSystem")

function SwitchModeSystem:init()
    self.destroyeds = self.world:get_table(Components.Destroyed)
    self.new_modes = self.world:get_table(EComponents.NewEditorMode)
    self.modes = self.world:get_table(EComponents.EditorMode)

    self.clear_filter = self.world:create_filter(EComponents.EditorMode, exc(EComponents.NewEditorMode))
    self.filter = self.world:create_filter(EComponents.NewEditorMode)
end

function SwitchModeSystem:execute()
    for _, entity in self.filter:reverse_entities() do
        for _, clear_entity in self.clear_filter:entities() do
            self.destroyeds:get_or_add(clear_entity)
        end

        self.modes:get_or_add(entity)

        self.new_modes:del(entity)
    end
end

return SwitchModeSystem