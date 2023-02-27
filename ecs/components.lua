local ecstasy = require "external.ecstasy"

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
	Tower = {  },
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
	Health = { reset = function(self) self.value = 100 end }, 
	---@class FollowTarget : ecstasy.Component
	---@field speed number
	FollowTarget = { reset = function(self) self.speed = 1 end }, 
	---@class RotateToTarget : ecstasy.Component
	RotateToTarget = { }, 
	---@class Target : ecstasy.Component
	---@field target number
	Target = { reset = function(self) self.target = 0 end }, 
	---@class Speed : ecstasy.Component
	---@field value number
	Speed = { reset = function(self) self.value = 0 end }, 
	---@class ViewRadius : ecstasy.Component
	---@field radius number
	ViewRadius = { reset = function(self) self.radius = 0 end }, 
	---@class Parent : ecstasy.Component
	---@field entity number
	Parent = { reset = function(self) self.entity = 0 end }, 
	---@class AttachToParent : ecstasy.Component
	---@field dx number
	---@field dy number
	---@field drot number
	AttachToParent = { reset = function(self) self.dx = 0 self.dy = 0 self.drot = 0 end }, 
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
	MonsterCreateRequest = { reset = function(self) self.hp = 100 self.initial_waypoint = nil self.reward = 0 self.damage = 1 end }, 
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
	Frozen = { reset = function(self) self.cooldown = 0 self.initial_speed = vmath.vector3() end }, 
	---@class DestroyOnNoTarget : ecstasy.Component
	DestroyOnNoTarget = { }, 
	---@class Reward : ecstasy.Component
	---@field value number
	Reward = { reset = function(self) self.value = 0 end }, 
	---@class DestroyOnCastleReached : ecstasy.Component
	DestroyOnCastleReached = { reset = function(self)  end }, 
	---@class Castle : ecstasy.Component
	Castle = { reset = function(self)  end }, 
}