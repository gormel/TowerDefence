local ecstasy = require "external.ecstasy"
local constants = require "ecs.constants"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")
local EComponents = require("ecs.editor_components")

---@class SetWaypointSystem : ecstasy.System
local SetWaypointSystem = ecstasy.System("SetWaypointSystem")

function SetWaypointSystem:init()
    self.pointers = self.world:get_table(Components.PointerInput)
    self.positions = self.world:get_table(Components.Position)
	self.cell_rounds = self.world:get_table(Components.RoundToCell)
	self.waypoints = self.world:get_table(Components.Waypoint)
	self.lasts = self.world:get_table(EComponents.LastWaypoint)
	self.roots = self.world:get_table(EComponents.RootWaypoint)
	self.connections = self.world:get_table(EComponents.Connection)
	self.attaches = self.world:get_table(EComponents.AttachConnectionView)
    
    self.last_waypoint_filter = self.world:create_filter(EComponents.LastWaypoint, Components.Waypoint)
    self.mode_filter = self.world:create_filter(EComponents.RouteEditorMode)
    self.clear_mode_filter = self.world:create_filter(EComponents.RouteEditorMode, Components.Destroyed)
	self.filter = self.world:create_filter(Components.MouseDownInput, Components.PointerInput)
end

function SetWaypointSystem:execute()
    for _, entity in self.filter:entities() do
        for _, _ in self.mode_filter:entities() do
            local pointer = self.pointers:get(entity)

            local waypoint_entity = self.world:new_entity()
            self.waypoints:add(waypoint_entity)
            local waypoint_pos = self.positions:add(waypoint_entity)
            waypoint_pos.x = pointer.x
            waypoint_pos.y = pointer.y
            self.cell_rounds:add(waypoint_entity)

            local view_entity = self.world:new_entity()
            local vew_resource = self.world:add_component(Components.Resource, view_entity)
            vew_resource.factory_url = constants.FACTORY_URL_EDITOR_WAYPOINT
            local view_parent = self.world:add_component(Components.Parent, view_entity)
            view_parent.entity = waypoint_entity
            self.world:add_component(Components.AttachToParent, view_entity)

            local is_root = true
            for _, last_waypoint_entity in self.last_waypoint_filter:reverse_entities() do
                local last_waypoint = self.waypoints:get(last_waypoint_entity)
                last_waypoint.next = waypoint_entity
                self.lasts:del(last_waypoint_entity)
                is_root = false

                local connection_entity = self.world:new_entity()
                local connection = self.connections:add(connection_entity)
                connection.a_entity = last_waypoint_entity
                connection.b_entity = waypoint_entity
                self.attaches:add(connection_entity)
            end

            self.lasts:add(waypoint_entity)
            if is_root then
                self.roots:add(waypoint_entity)
            end
        end
    end

    for _, _ in self.clear_mode_filter:entities() do
        for _, waypoint_entity in self.last_waypoint_filter:reverse_entities() do
            self.lasts:del(waypoint_entity)
        end
    end
end

return SetWaypointSystem