local ecstasy = require "external.ecstasy"

---@alias status "Frozen" | "Poisoned"

return {
	---@class PointerInput : ecstasy.Component
	---@field x number
	---@field y number
	PointerInput = { reset = function(self) self.x = 0 self.y = 0 end },
	---@class MouseDownInput : ecstasy.Component
	MouseDownInput = {  },
	---@class MouseHoverInput : ecstasy.Component
	MouseHoverInput = {  },
	
	---@class Destroyed : ecstasy.Component
	Destroyed = {  },

	---@class RoundToCell : ecstasy.Component
	RoundToCell = {  },
	---@class FollowPointer : ecstasy.Component
	FollowPointer = {  },
	---@class Position : ecstasy.Component
	---@field x number
	---@field y number
	Position = { reset = function(self) self.x = 0 self.y = 0 end },
	---@class Rotation : ecstasy.Component
	---@field angle number
	Rotation = { reset = function(self)	self.angle = 0 end },

	---@class Resource : ecstasy.Component
	---@field factory_url string
	Resource = { reset = function(self)	self.factory_url = "" end },
	---@class View : ecstasy.Component
	---@field id hash
	View = { reset = function(self) self.id = 0 end },

	---@class BlocksTower : ecstasy.Component
	BlocksTower = { },
	---@class Tower : ecstasy.Component
	---@field tower_type string
	Tower = { reset = function(self) self.tower_type = "" end },
	---@class TowerCreateRequest : ecstasy.Component
	---@field tower_type string
	TowerCreateRequest = { reset = function(self) self.tower_type = "" end },
	---@class SelectedTowerType : ecstasy.Component
	---@field tower_type string
	SelectedTowerType = { reset = function(self) self.tower_type = ""	end },
	---@class SelectTowerTypeRequest : ecstasy.Component
	---@field tower_type string
	SelectTowerTypeRequest = { reset = function(self) self.tower_type = "" end },

	---@class Money : ecstasy.Component
	---@field value number
	Money = { reset = function(self) self.value = 0 end	},

	---@class Health : ecstasy.Component
	---@field value number
	---@field max_value number
	Health = { reset = function(self) self.value = 100 self.max_value = 100 end },
	---@class FollowTarget : ecstasy.Component
	FollowTarget = { reset = function(self) end },
	---@class RotateToTarget : ecstasy.Component
	RotateToTarget = { },
	---@class Target : ecstasy.Component
	---@field target number
	Target = { reset = function(self) self.target = 0 end },
	---@class Speed : ecstasy.Component
	---@field value number
	---@field initial_value? number
	Speed = { reset = function(self) self.value = 0 self.initial_value = nil end },
	---@class ViewRadius : ecstasy.Component
	---@field radius number
	ViewRadius = { reset = function(self) self.radius = 0 end },
	---@class Parent : ecstasy.Component
	---@field entity number
	Parent = { reset = function(self) self.entity = 0 end },
	---@class AttachToParent : ecstasy.Component
	---@field dx number
	---@field dy number
	---@field da number
	---@field sync_position boolean
	---@field sync_angle boolean
	AttachToParent = { reset = function(self) self.dx = 0 self.dy = 0 self.da = 0 self.sync_position = true self.sync_angle = true end },
	---@class MonsterSpawner : ecstasy.Component
	---@field setup MonsterSpawnerSetup
	---@field wave number
	MonsterSpawner = { reset = function (self) self.setup = nil self.wave = 1 end },
	---@class WaveNumber : ecstasy.Component
	---@field value number
	WaveNumber = { reset = function(self) self.value = 1 end },
	---@class Cooldown : ecstasy.Component
	---@field value number
	Cooldown = { reset = function(self) self.value = 0 end },
	---@class Monster : ecstasy.Component
	Monster = {  },
	---@class MonsterCreateRequest : ecstasy.Component
	---@field hp number
	---@field initial_waypoint number
	---@field reward number
	---@field damage number
	---@field speed number
	---@field monster_entity? number
	MonsterCreateRequest = { reset = function(self) self.monster_entity = nil self.hp = 100 self.initial_waypoint = nil self.reward = 0 self.damage = 1 self.speed = 25 end },
	---@class Velocity : ecstasy.Component
	---@field x number
	---@field y number
	Velocity = { reset = function(self) self.x = 0 self.y = 0 end },
	---@class TargetReached : ecstasy.Component
	---@field target number
	TargetReached = { reset = function(self) self.target = 0 end },
	---@class Waypoint : ecstasy.Component
	---@field next number
	Waypoint = { reset = function(self) self.next = 0 end },
	---@class TargetMonsterInViewRadius : ecstasy.Component
	TargetMonsterInViewRadius = {  },
	---@class FreeOutOfViewTarget : ecstasy.Component
	FreeOutOfViewTarget = { },
	---@class Damage : ecstasy.Component
	---@field value number
	Damage = { reset = function(self) self.value = 0 end },
	---@class DealDamageOnTargetReached : ecstasy.Component
	DealDamageOnTargetReached = { },
	---@class DestroyOnTargetReached : ecstasy.Component
	DestroyOnTargetReached = { },
	---@class FreezeOnTargetReached : ecstasy.Component
	---@field duration number
	FreezeOnTargetReached = { reset = function(self) self.duration = 0 end },
	---@class Frozen : ecstasy.Component
	---@field cooldown number
	---@field power number
	---@field status_id string
	Frozen = { reset = function(self) self.cooldown = 0 self.power = 1 self.status_id = nil end },
	---@class FrozenStatus : ecstasy.Component
	FrozenStatus = { reset = function(self)  end },
	---@class HasFrozenStatus : ecstasy.Component
	---@field entity number
	HasFrozenStatus = { reset = function(self) self.entity = 0 end },
	---@class Poisoned : ecstasy.Component
	---@field cooldown number
	---@field tick_time number
	---@field tick_count number
	---@field tick_damage number
	---@field status_id string
	Poisoned = { reset = function(self) self.cooldown = 0 self.tick_time = 0 self.tick_count = 0 self.tick_damage = 0 self.status_id = nil end },
	---@class PoisonedStatus : ecstasy.Component
	PoisonedStatus = { reset = function(self)  end },
	---@class HasPoisonedStatus : ecstasy.Component
	---@field entity number
	HasPoisonedStatus = { reset = function(self) self.entity = 0 end },
	---@class DestroyOnNoTarget : ecstasy.Component
	DestroyOnNoTarget = { },
	---@class Reward : ecstasy.Component
	---@field value number
	Reward = { reset = function(self) self.value = 0 end },
	---@class DestroyOnCastleReached : ecstasy.Component
	DestroyOnCastleReached = { reset = function(self)  end },
	---@class Castle : ecstasy.Component
	Castle = { reset = function(self)  end },
	---@class ApplyStatus : ecstasy.Component
	---@field status status[]
	ApplyStatus = { reset = function(self) self.status = {} end },
	---@class ApplyStatusOnTargetReached : ecstasy.Component
	---@field status status[]
	ApplyStatusToTargetOnTargetReached = { reset = function(self) self.status = {} end },
	---@class Blocked : ecstasy.Component
	---@field blocker_entities number[]
	Blocked = { reset = function(self) self.blocker_entities = {} end },
	---@class Blocker : ecstasy.Component
	Blocker = { reset = function(self)  end },
	---@class NextWaveRequest : ecstasy.Component
	NextWaveRequest = { reset = function(self)  end },
	---@class HealthView : ecstasy.Component
	---@field health_value? number
	HealthBar = { reset = function(self) self.health_value = nil end },
	---@class HasHealthBar : ecstasy.Component
	---@field entity number
	HasHealthBar = { reset = function(self) self.entity = 0 end },
}