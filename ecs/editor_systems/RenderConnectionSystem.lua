local ecstasy    = require "external.ecstasy"
local Components = require("ecs.components")
local EComponents = require("ecs.editor_components")

local exc, inc   = ecstasy.exc, ecstasy.inc
local sqrt = math.sqrt

---@class RenderConnectionSystem : ecstasy.System
local RenderConnectionSystem = ecstasy.System("RenderConnectionSystem")

function RenderConnectionSystem:init()
    self.views = self.world:get_table(Components.View)
    self.positions = self.world:get_table(Components.Position)
    self.connections = self.world:get_table(EComponents.Connection)
    self.parents = self.world:get_table(Components.Parent)

    self.filter = self.world:create_filter(EComponents.ConnectionView, Components.View, Components.Parent, Components.AttachToParent)
end

local function sq(x)
    return x * x
end

---@param a Position
---@param b Position
local function dist(a, b)
    return sqrt(sq(a.x - b.x) + sq(a.y - b.y) + sq(a.z - b.z))
end

function RenderConnectionSystem:execute()
    for _, entity in self.filter:entities() do
        local parent = self.parents:get(entity)
        local view = self.views:get(entity)
        local connection = self.connections:get(parent.entity)

        local a_pos = self.positions:get(connection.a_entity)
        local b_pos = self.positions:get(connection.b_entity)
        local dst = dist(a_pos, b_pos)

        go.set_scale(vmath.vector3(dst, 5, 1), view.id)
    end
end

return RenderConnectionSystem
