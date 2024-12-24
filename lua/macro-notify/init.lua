local M = {}

-- Default settings
M.options = {
	message_start = "macro: ", -- Message for macro start
	message_end = "ended: ", -- Message for macro end
	icon_start = "🚀", -- Icon for macro start
	icon_end = "💀", -- Icon for macro end
}

-- Format notification message with icon
function M.format_notification(icon, message)
	return icon, message
end

-- Notification for macro start
local function notify_macro_start(register)
	local icon, message = M.format_notification(M.options.icon_start, M.options.message_start .. register)
	vim.notify(message, vim.log.levels.WARN, { icon = icon })
end

-- Notification for macro end
local function notify_macro_end(register)
	local icon, message = M.format_notification(M.options.icon_end, M.options.message_end .. register)
	vim.notify(message, vim.log.levels.WARN, { icon = icon })
end

-- Set up autocommands
function M.setup(opts)
	-- Merge user settings with defaults
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})

	-- Notification on macro start
	vim.api.nvim_create_autocmd("RecordingEnter", {
		callback = function()
			local register = vim.fn.reg_recording()
			if register ~= "" then
				notify_macro_start(register)
			end
		end,
		desc = "Notify macro start",
	})

	-- Notification on macro end
	vim.api.nvim_create_autocmd("RecordingLeave", {
		callback = function()
			local register = vim.fn.reg_recording()
			if register ~= "" then
				notify_macro_end(register)
			end
		end,
		desc = "Notify macro end",
	})
end

return M
