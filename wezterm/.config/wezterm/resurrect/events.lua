-- File: resurrect/events.lua
local wezterm = require("wezterm")
local suppress_notification = false

local function getWindow()
	local windows = wezterm.gui.gui_windows()
	for _, window in ipairs(windows) do
		if window:is_focused() then
			return window
		end
	end
	return windows[1] -- Lua arrays start at 1, not 0
end

wezterm.on("resurrect.error", function(error)
	wezterm.log_info("resurrect.error triggered")
	wezterm.log_info(error)
	local window = getWindow()
	wezterm.log_info("window object: " .. tostring(window))
	if window then
		window:toast_notification("Wezterm - ERROR", error)
	end
end)

wezterm.on("resurrect.periodic_save", function()
	suppress_notification = true
end)

wezterm.on("resurrect.save_state.finished", function(session_path)
	local window = getWindow()
	local is_workspace_save = session_path:find("state/workspace")
	if is_workspace_save == nil then
		return
	end
	if suppress_notification then
		suppress_notification = false
		return
	end
	local path = session_path:match(".+/([^+]+)$")
	local name = path:match("^(.+)%.json$")
	if window then
		window:toast_notification("Wezterm - Save workspace", "Saved workspace " .. name .. "\n\n" .. session_path)
	end
end)

wezterm.on("resurrect.load_state.finished", function(name, type)
	local msg = "Completed loading " .. type .. " state: " .. name
	local window = getWindow()
	if window then
		window:toast_notification("Wezterm - Restore session", msg)
	end
end)
