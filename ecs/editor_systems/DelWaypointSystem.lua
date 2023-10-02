local ecstasy    = require "external.ecstasy"
local Components = require("ecs.components")
local EComponents = require("ecs.editor_components")
local constants   = require("ecs.constants")

local exc, inc   = ecstasy.exc, ecstasy.inc

---@class DelWaypointSystem : ecstasy.System
local DelWaypointSystem = ecstasy.System("DelWaypointSystem")

function DelWaypointSystem:init()
    self.pointers = self.world:get_table(Components.PointerInput)
    self.positions = self.world:get_table(Components.Position)
    self.waypoints = self.world:get_table(Components.Waypoint)
    self.destroyeds = self.world:get_table(Components.Destroyed)
	self.connections = self.world:get_table(EComponents.Connection)
	self.attaches = self.world:get_table(EComponents.AttachConnectionView)
	self.roots = self.world:get_table(EComponents.RootWaypoint)
    
    self.waypoint_filter = self.world:create_filter(Components.Waypoint, Components.Position)
    self.mode_filter = self.world:create_filter(EComponents.RemoveWaypointEditorMode)
	self.filter = self.world:create_filter(Components.MouseDownInput, Components.PointerInput)
end

function DelWaypointSystem:execute()
    for _, entity in self.filter:entities() do
        for _, _ in self.mode_filter:entities() do
            local pointer = self.pointers:get(entity)
            for _, wp_entity in self.waypoint_filter:entities() do
                local wp_pos = self.positions:get(wp_entity)
                local dx = pointer.x - wp_pos.x
                local dy = pointer.y - wp_pos.y
                local dist_sq = dx * dx + dy * dy
                if dist_sq < constants.CELL_SIZE * constants.CELL_SIZE / 4 then
                    local waypoint = self.waypoints:get(wp_entity)
                    local child = waypoint.next
                    local parent = nil
                    for _, parent_wp_entity in self.waypoint_filter:entities() do
                        local parent_wp = self.waypoints:get(parent_wp_entity)
                        if parent_wp.next == wp_entity then
                            parent = parent_wp_entity
                            break
                        end
                    end

                    self.destroyeds:add(wp_entity)

                    if parent ~= nil then
                        local parent_wp = self.waypoints:get(parent)
                        parent_wp.next = child
                        if child ~= nil then
                            local connection_entity = self.world:new_entity()
                            local connection = self.connections:add(connection_entity)
                            connection.a_entity = parent
                            connection.b_entity = child
                            self.attaches:add(connection_entity)
                        end
                    elseif child ~= nil then
                        self.roots:add(child)
                    end
                    break
                end
            end
        end
    end
end

return DelWaypointSystem
