local ecstasy = require "external.ecstasy"
local Components = require("ecs.components")
local const = require("ecs.constants")
local setup = require "ecs.setup"

---@class CreateTowerSystem : ecstasy.System
local CreateTowerSystem = ecstasy.System("CreateTowerSystem")

function CreateTowerSystem:init()
	self.request_components = self.world:get_table(Components.TowerCreateRequest)
	self.tower_components = self.world:get_table(Components.Tower)
	self.resource_components = self.world:get_table(Components.Resource)
	self.parent_components = self.world:get_table(Components.Parent)
	self.attach_to_parent_components = self.world:get_table(Components.AttachToParent)
	self.rotate_to_target_components = self.world:get_table(Components.RotateToTarget)
	self.free_out_of_view_target_components = self.world:get_table(Components.FreeOutOfViewTarget)
	self.target_monster_in_view_radius_components = self.world:get_table(Components.TargetMonsterInViewRadius)
	self.view_radius_components = self.world:get_table(Components.ViewRadius)
	self.blocks_tower_components = self.world:get_table(Components.BlocksTower)
	self.damage_components = self.world:get_table(Components.Damage)
	self.filter_components = self.world:get_table(Components.TargetFilters)
	self.kill_counters = self.world:get_table(Components.KillCounter)
	self.upgrades = self.world:get_table(Components.AvaliableUpgrades)
	
	self.requests_filter = self.world:create_filter(Components.TowerCreateRequest, Components.Position)
end

function CreateTowerSystem:execute()
	for _, entity in self.requests_filter:reverse_entities() do
		local type = self.request_components:get(entity).tower_type
		local tower_setup = setup.Towers[type]
		
		local tower = self.tower_components:add(entity)
		tower.tower_type = type

		local view_radius = self.view_radius_components:add(entity)
		view_radius.radius = tower_setup.radius

		local damage = self.damage_components:add(entity)
		damage.value = tower_setup.damage

		if #tower_setup.target_filters > 0 then
			local filters = self.filter_components:add(entity)
			for _, filter in ipairs(tower_setup.target_filters) do
				table.insert(filters.filters, filter)
			end
		end

		local upgrades = self.upgrades:add(entity)
		for upgrade_type, _ in pairs(setup.TowerUpgrades[type] or {}) do
			table.insert(upgrades.upgrades, upgrade_type)
		end

		self.target_monster_in_view_radius_components:add(entity)
		self.rotate_to_target_components:add(entity)
		self.free_out_of_view_target_components:add(entity)
		self.blocks_tower_components:add(entity)
		self.kill_counters:add(entity)

		local tower_view_entity = self.world:new_entity()
		local resource = self.resource_components:add(tower_view_entity)
		resource.factory_url = tower_setup.factory_url
		local parent = self.parent_components:add(tower_view_entity)
		parent.entity = entity
		self.attach_to_parent_components:add(tower_view_entity)

		self.request_components:del(entity)
	end
end

return CreateTowerSystem