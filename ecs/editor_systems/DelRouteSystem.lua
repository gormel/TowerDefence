local ecstasy    = require "external.ecstasy"
local Components = require("ecs.components")
local EComponents = require("ecs.editor_components")
local constants   = require("ecs.constants")

local exc, inc   = ecstasy.exc, ecstasy.inc

---@class DelRouteSystem : ecstasy.System
local DelRouteSystem = ecstasy.System("DelRouteSystem")

function DelRouteSystem:init()
    self.pointers = self.world:get_table(Components.PointerInput)
    self.positions = self.world:get_table(Components.Position)
    self.waypoints = self.world:get_table(Components.Waypoint)
    self.destroyeds = self.world:get_table(Components.Destroyed)
	self.connections = self.world:get_table(EComponents.Connection)
	self.attaches = self.world:get_table(EComponents.AttachConnectionView)
    
    self.root_waypoint_filter = self.world:create_filter(EComponents.RootWaypoint, Components.Position)
    self.waypoint_filter = self.world:create_filter(Components.Waypoint, Components.Position)
    self.mode_filter = self.world:create_filter(EComponents.RemoveRouteEditorMode)
	self.filter = self.world:create_filter(Components.MouseDownInput, Components.PointerInput)
end

---@param self DelRouteSystem
---@param root_entity number
---@param entity number
local function is_child_of(self, root_entity, entity)
    local it = root_entity
    while it ~= nil do
        if it == entity then
            return true
        end

        local waypoint = self.waypoints:get(it)
        it = waypoint.next
    end

    return false
end

function DelRouteSystem:execute()
    for _, entity in self.filter:entities() do
        for _, _ in self.mode_filter:entities() do
            local pointer = self.pointers:get(entity)
            for _, wp_entity in self.waypoint_filter:entities() do
                local wp_pos = self.positions:get(wp_entity)
                local dx = pointer.x - wp_pos.x
                local dy = pointer.y - wp_pos.y
                local dist_sq = dx * dx + dy * dy
                if dist_sq < constants.CELL_SIZE * constants.CELL_SIZE / 4 then
                    for _, root_entity in self.root_waypoint_filter:entities() do
                        if is_child_of(self, root_entity, wp_entity) then
                            local del_entity = root_entity
                            while del_entity ~= nil do
                                self.destroyeds:add(del_entity)
                                local waypoint = self.waypoints:get(del_entity)
                                del_entity = waypoint.next
                            end
                            break
                        end
                    end
                    break
                end
            end
        end
    end
end

return DelRouteSystem
