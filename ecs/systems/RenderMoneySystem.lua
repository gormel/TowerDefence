local ecstasy = require "external.ecstasy"
local const = require "ecs.constants"
local exc, added, removed = ecstasy.exc, ecstasy.added, ecstasy.removed
local Components = require("ecs.components")
local Msg = require("main.mesages")

local RenderMoneySystem = ecstasy.System("RenderMoneySystem")

function RenderMoneySystem:init()
	self.money_components = self.world:get_table(Components.Money)
end

function RenderMoneySystem:execute()
	for _, money in self.money_components:components() do
		msg.post(const.URL_GUI, Msg.UPDATE_MONEY, { money = money.value })
	end
end

return RenderMoneySystem