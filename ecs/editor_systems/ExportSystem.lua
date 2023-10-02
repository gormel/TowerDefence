local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")
local EComponents = require("ecs.editor_components")

---@class ExportSystem : ecstasy.System
local ExportSystem = ecstasy.System("ExportSystem")

function ExportSystem:init()
    self.positions = self.world:get_table(Components.Position)
    self.waypoints = self.world:get_table(Components.Waypoint)

    self.route_filter = self.world:create_filter(Components.Waypoint, EComponents.RootWaypoint, Components.Position)
    self.castle_filter = self.world:create_filter(Components.Castle, Components.Position)
    self.filter = self.world:create_filter(EComponents.ExportMap)
end

local serialize

local serialize_map = {
  [ "boolean" ] = tostring,
  [ "nil"     ] = tostring,
  [ "string"  ] = function(v) return string.format("%q", v) end,
  [ "number"  ] = function(v)
    if      v ~=  v     then return  "0/0"      --  nan
    elseif  v ==  1 / 0 then return  "1/0"      --  inf
    elseif  v == -1 / 0 then return "-1/0" end  -- -inf
    return tostring(v)
  end,
  [ "table"   ] = function(t, stk)
    stk = stk or {}
    if stk[t] then error("circular reference") end
    local rtn = {}
    stk[t] = true
    for k, v in pairs(t) do
      rtn[#rtn + 1] = "[" .. serialize(k, stk) .. "]=" .. serialize(v, stk)
    end
    stk[t] = nil
    return "{" .. table.concat(rtn, ",") .. "}"
  end
}

setmetatable(serialize_map, {
  __index = function(_, k) error("unsupported serialize type: " .. k) end
})

serialize = function(x, stk)
  return serialize_map[type(x)](x, stk)
end

function ExportSystem:execute()
    for _, entity in self.filter:entities() do
        ---@class export.Map : setup.Map
        local map = {}
        for _, castle_entity in self.castle_filter:entities() do
            local pos = self.positions:get(castle_entity)

            map.Castle = {
                x = pos.x,
                y = pos.y
            }
        end

        map.Routes = {}
        local route_idx = 1
        for _, route_entity in self.route_filter:entities() do
            local current_entity = route_entity
            ---@type setup.Map.Point[]
            local route = {}

            repeat
                local waypoint = self.waypoints:get(current_entity)
                local pos = self.positions:get(current_entity)

                table.insert(route, {
                    x = pos.x,
                    y = pos.y,
                })

                current_entity = waypoint.next
            until current_entity == nil
            
            if #route > 0 then
                map.Routes["Route_"..tostring(route_idx)] = route
                route_idx = route_idx + 1
            end
        end
        
        pprint(serialize(map))
    end
end

return ExportSystem