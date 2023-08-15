local ecstasy = require "external.ecstasy"
local constants = require "ecs.constants"
local setup     = require "ecs.setup"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class AttachUpgradeViewSystem : ecstasy.System
local AttachUpgradeViewSystem = ecstasy.System("AttachUpgradeViewSystem")

function AttachUpgradeViewSystem:init()
    self.links = self.world:get_table(Components.HasUpgradeView)
    self.resources = self.world:get_table(Components.Resource)
	self.parents = self.world:get_table(Components.Parent)
	self.attach_to_parents = self.world:get_table(Components.AttachToParent)
	self.views = self.world:get_table(Components.UpgradeView)
	self.destroyeds = self.world:get_table(Components.Destroyed)
	self.upgrades = self.world:get_table(Components.AvaliableUpgrades)
	self.detectors = self.world:get_table(Components.ClickDetector)
	self.towers = self.world:get_table(Components.Tower)
    
    self.add_filter = self.world:create_filter(Components.AvaliableUpgrades, Components.Selected, exc(Components.HasUpgradeView), Components.Tower)
    self.del_filter = self.world:create_filter(Components.HasUpgradeView, exc(Components.Selected))
end

function AttachUpgradeViewSystem:execute()
    for _, entity in self.add_filter:reverse_entities() do
        local upgrades = self.upgrades:get(entity)
        local link = self.links:get_or_add(entity)
        local tower = self.towers:get_or_add(entity)

        local idx = 0
        for _, upgrade in ipairs(upgrades.upgrades) do
            local upgrade_cfg = setup.TowerUpgrades[tower.tower_type][upgrade]

            local angle = math.pi / 2
            if #upgrades.upgrades > 1 then
                angle = idx / (#upgrades.upgrades - 1) * math.pi
            end

            local view_entity = self.world:new_entity()
            local res = self.resources:add(view_entity)
            res.factory_url = upgrade_cfg.icon_factory_url
            local parent = self.parents:add(view_entity)
            parent.entity = entity
            local attach = self.attach_to_parents:add(view_entity)
            attach.sync_angle = false
            attach.dz = 0.1
            attach.dx =  math.cos(angle) * (constants.CELL_SIZE) / 2
            attach.dy = -math.sin(angle) * (constants.CELL_SIZE) / 2
            local view = self.views:add(view_entity)
            view.upgrade = upgrade
            view.tower_entity = entity
            self.detectors:add(view_entity)
    
            table.insert(link.view_entities, view_entity)
            idx = idx + 1
        end
    end

    for _, entity in self.del_filter:reverse_entities() do
        local link = self.links:get(entity)
        for _, view_entity in ipairs(link.view_entities) do
            self.destroyeds:add(view_entity)
        end

        self.links:del(entity)
    end
end

return AttachUpgradeViewSystem