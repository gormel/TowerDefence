local ecstasy = require "external.ecstasy"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class UpgradeViewClickedSystem : ecstasy.System
local UpgradeViewClickedSystem = ecstasy.System("UpgradeViewClickedSystem")

function UpgradeViewClickedSystem:init()
    self.views = self.world:get_table(Components.UpgradeView)
    self.upgrades = self.world:get_table(Components.UpgradeTower)

    self.filter = self.world:create_filter(Components.Clicked, Components.UpgradeView)
end

function UpgradeViewClickedSystem:execute()
    for _, entity in self.filter:entities() do
        local view = self.views:get(entity)
        local upgrade = self.upgrades:add(view.tower_entity)
        upgrade.upgrade = view.upgrade
        print("clicked")
    end
end

return UpgradeViewClickedSystem