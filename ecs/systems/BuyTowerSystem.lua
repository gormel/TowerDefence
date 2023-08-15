local ecstasy = require "external.ecstasy"
local setup   = require "ecs.setup"
local const = require "ecs.constants"
local exc, inc, added, removed, changed = ecstasy.exc, ecstasy.inc, ecstasy.added, ecstasy.removed, ecstasy.changed
local Components = require("ecs.components")

---@class BuyTowerSystem : ecstasy.System
local BuyTowerSystem = ecstasy.System("BuyTowerSystem")

function BuyTowerSystem:init()
	self.destroyed_components = self.world:get_table(Components.Destroyed)
	self.request_components = self.world:get_table(Components.TowerBuyRequest)
	self.position_components = self.world:get_table(Components.Position)
	self.tower_components = self.world:get_table(Components.TowerCreateRequest)
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
	
	self.requests_filter = self.world:create_filter(Components.TowerBuyRequest, Components.Position)
	self.towers_filter = self.world:create_filter(Components.BlocksTower, Components.Position)
end

function BuyTowerSystem:execute()
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
				end
				break
			end
		end
	end
end

return BuyTowerSystem