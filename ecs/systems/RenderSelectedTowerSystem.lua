local ecstasy = require "external.ecstasy"
local setup   = require "ecs.setup"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")
local const = require "ecs.constants"
local msgs = require "main.mesages"

---@class RenderSelectedTowerSystem : ecstasy.System
local RenderSelectedTowerSystem = ecstasy.System("RenderSelectedTowerSystem")

function RenderSelectedTowerSystem:init()
    self.towers = self.world:get_table(Components.Tower)
    self.damages = self.world:get_table(Components.Damage)
    self.killses = self.world:get_table(Components.KillCounter)

    self.filter = self.world:create_filter(Components.Selected, Components.Tower, Components.Damage, Components.KillCounter)
end

function RenderSelectedTowerSystem:execute()
    local has_any = false
    for _, entity in self.filter:entities() do
        local tower = self.towers:get(entity)
        local damage = self.damages:get(entity)
        local kills = self.killses:get(entity)
        local tower_cfg = setup.Towers[tower.tower_type]

        has_any = true
        msg.post(const.URL_GUI, msgs.UPDATE_SELECTED_TOWER, {
            tower_type = tower.tower_type,
            dps = damage.value / const.SHOOT_DELAY,
            statuses = tower_cfg.apply_status,
            kills = kills.value
        })
        break
    end

    if not has_any then
        msg.post(const.URL_GUI, msgs.UPDATE_SELECTED_TOWER, { empty = true })
    end
end

return RenderSelectedTowerSystem