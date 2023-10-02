---@class EditorComponents
return {
    ---@class NewEditorMode : ecstasy.Component
    NewEditorMode = { reset = function(self)  end },
    ---@class EditorMode : ecstasy.Component
    EditorMode = { reset = function(self)  end },
    ---@class CastleEditorMode : ecstasy.Component
    CastleEditorMode = { reset = function(self)  end },
    ---@class RouteEditorMode : ecstasy.Component
    RouteEditorMode = { reset = function(self)  end },
    ---@class RemoveWaypointEditorMode : ecstasy.Component
    RemoveWaypointEditorMode = { reset = function(self)  end },
    ---@class RemoveRouteEditorMode : ecstasy.Component
    RemoveRouteEditorMode = { reset = function(self)  end },
    ---@class LastWaypoint : ecstasy.Component
    LastWaypoint = { reset = function(self)  end },
    ---@class RootWaypoint : ecstasy.Component
    RootWaypoint = { reset = function(self)  end },
    ---@class ExportMap : ecstasy.Component
    ExportMap = { reset = function(self)  end },
    ---@class Connection : ecstasy.Component
    ---@field a_entity number
    ---@field b_entity number
    Connection = { reset = function(self) self.a_entity = 0 self.b_entity = 0 end },
    ---@class AttachConnectionView : ecstasy.Component
    AttachConnectionView = { reset = function(self)  end },
    ---@class ConnectionView : ecstasy.Component
    ConnectionView = { reset = function(self)  end },
}