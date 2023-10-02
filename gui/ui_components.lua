local M = {}

M.buttons = {}

function M.add_button(node, callback)
	table.insert(M.buttons, { node = node, callback = callback })
end

function M.on_input(action_id, action)
	if action_id == hash("touch") and action.pressed then
		for _, button in ipairs(M.buttons) do
			if gui.is_enabled(button.node, true) and button.callback and gui.pick_node(button.node, action.x, action.y) then
				button.callback()
				return true
			end
		end
	end
	return false
end

function M.final()
    for i = #M.buttons, 1, -1 do
        table.remove(M.buttons, i)
    end
end

return M