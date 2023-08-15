local ecstasy = require "external.ecstasy"
local Components = require("ecs.components")
local const = require("ecs.constants")
local setup = require "ecs.setup"

---@class CreateTowerSystem : ecstasy.System
local CreateTowerSystem = ecstasy.System("CreateTowerSystem")

function CreateTowerSystem:init()
	self.destroyed_components = self.world:get_table(Components.Destroyed)
	self.request_components = self.world:get_table(Components.TowerCreateRequest)
	self.position_components = self.world:get_table(Components.Position)
	self.tower_components = self.world:get_table(Components.Tower)
	self.resource_components = self.world:get_table(Components.Resource)
	self.money_components = self.world:get_table(Components.Money)
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
	self.towers_filter = self.world:create_filter(Components.BlocksTower, Components.Position)
end

function CreateTowerSystem:execute()
	for _, entity in self.requests_filter:entities() do
		self.destroyed_components:add(entity)

		local type = self.request_components:get(entity).tower_type
		local tower_setup = setup.Towers[type]
		
		local pos = self.position_components:get(entity)
		
		local busy = false
		for _, tower_entity in self.towers_filter:entities() do
			local tower_pos = self.position_components:get(tower_entity)
			local dist_x = pos.x - tower_pos.x
			local dist_y = pos.y - tower_pos.y
			local dist = dist_x * dist_x + dist_y * dist_y
			if dist < const.CELL_SIZE * const.CELL_SIZE / 4 then
				busy = true
				break
			end
		end

		if not busy then
			for _, money in self.money_components:components() do
				if (money.value >= tower_setup.cost) then
					money.value = money.value - tower_setup.cost
					
					local tower_entity = self.world:new_entity()
					local tower = self.tower_components:add(tower_entity)
					tower.tower_type = type
					local tower_pos = self.position_components:add(tower_entity)
					tower_pos.x = pos.x
					tower_pos.y = pos.y

					local view_radius = self.view_radius_components:add(tower_entity)
					view_radius.radius = tower_setup.radius

					local damage = self.damage_components:add(tower_entity)
					damage.value = tower_setup.damage

					if #tower_setup.target_filters > 0 then
						local filters = self.filter_components:add(tower_entity)
						for _, filter in ipairs(tower_setup.target_filters) do
							table.insert(filters.filters, filter)
						end
					end

					local upgrades = self.upgrades:add(tower_entity)
					for upgrade_type, _ in pairs(setup.TowerUpgrades[type] or {}) do
						table.insert(upgrades.upgrades, upgrade_type)
					end

					self.target_monster_in_view_radius_components:add(tower_entity)
					self.rotate_to_target_components:add(tower_entity)
					self.free_out_of_view_target_components:add(tower_entity)
					self.blocks_tower_components:add(tower_entity)
					self.kill_counters:add(tower_entity)

					local tower_view_entity = self.world:new_entity()
					local resource = self.resource_components:add(tower_view_entity)
					resource.factory_url = tower_setup.factory_url
					local parent = self.parent_components:add(tower_view_entity)
					parent.entity = tower_entity
					self.attach_to_parent_components:add(tower_view_entity)
				end
				break
			end
		end
	end
end

return CreateTowerSystem