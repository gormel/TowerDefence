local ecstasy = require "external.ecstasy"
local setup   = require "ecs.setup"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class UpgradeTowerSystem : ecstasy.System
local UpgradeTowerSystem = ecstasy.System("UpgradeTowerSystem")

function UpgradeTowerSystem:init()
    self.upgrades = self.world:get_table(Components.UpgradeTower)
    self.destroyeds = self.world:get_table(Components.Destroyed)
    self.towers = self.world:get_table(Components.Tower)
    self.moneys = self.world:get_table(Components.Money)
    self.positions = self.world:get_table(Components.Position)
    self.creates = self.world:get_table(Components.TowerCreateRequest)

    self.filter = self.world:create_filter(Components.UpgradeTower, Components.Tower, Components.Position)
end

function UpgradeTowerSystem:execute()
    for _, entity in self.filter:reverse_entities() do
        local upgrade = self.upgrades:get(entity)
        local tower = self.towers:get(entity)
        local upgrade_cfg = setup.TowerUpgrades[tower.tower_type][upgrade.upgrade]
        if upgrade_cfg ~= nil then
            for _, money in self.moneys:components() do
                if money.value >= upgrade_cfg.cost then
                    money.value = money.value - upgrade_cfg.cost

                    local pos = self.positions:get(entity)

                    local next_entity = self.world:new_entity()
                    local create = self.creates:add(next_entity)
                    create.tower_type = upgrade.upgrade
                    local next_pos = self.positions:add(next_entity)
                    next_pos.x = pos.x
                    next_pos.y = pos.y
                    next_pos.z = pos.z

                    self.destroyeds:add(entity)
                end
                break
            end
        end

        self.upgrades:del(entity)
    end
end

return UpgradeTowerSystem