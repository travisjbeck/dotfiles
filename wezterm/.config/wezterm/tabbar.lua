local wezterm = require("wezterm")
local schemeName = "Tokyo Night"
local scheme = wezterm.get_builtin_color_schemes()[schemeName]

-- Define the separator characters
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
local RIGHT_ARROW = wezterm.nerdfonts.pl_left_soft_divider

-- Tab title function
function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- Use your Tokyo Night colors
	local edge_background = scheme.background
	local background = scheme.selected_bg
	local foreground = scheme.brights[1]

	-- Adjust colors for active and hover states
	if tab.is_active then
		background = scheme.brights[1]
		foreground = scheme.brights[7]
	end

	local edge_foreground = background
	local title = tab_title(tab)

	-- Add padding to the title
	title = " " .. wezterm.truncate_right(title, max_width - 4) .. " "

	return {
		{ Background = { Color = edge_foreground } },
		{ Foreground = { Color = edge_background } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

-- add the workspace name to the left and info to the rights
wezterm.on("update-status", function(window, pane)
	-- Workspace name
	local stat = window:active_workspace()
	local stat_color = scheme.brights[3]
	-- It's a little silly to have workspace name all the time
	-- Utilize this to display LDR or current key table name
	if window:active_key_table() then
		stat = window:active_key_table()
		stat_color = scheme.brights[4]
	end
	if window:leader_is_active() then
		stat = "LDR"
		stat_color = scheme.brights[6]
	end

	-- Left status (left of the tab line)
	window:set_left_status(wezterm.format({
		{ Background = { Color = scheme.background } },
		{ Foreground = { Color = stat_color } },
		{ Text = "  " },
		{ Text = wezterm.nerdfonts.oct_table .. " " .. stat .. " " },
		-- { Foreground = { Color = scheme.selected_bg } },
		-- { Text = RIGHT_ARROW },
	}))

	local basename = function(s)
		-- Nothing a little regex can't fix
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	-- Current working directory
	local cwd = pane:get_current_working_dir()
	if cwd then
		if type(cwd) == "userdata" then
			-- Wezterm introduced the URL object in 20240127-113634-bbcac864
			cwd = basename(cwd.file_path)
		else
			-- 20230712-072601-f4abf8fd or earlier version
			cwd = basename(cwd)
		end
	else
		cwd = ""
	end

	-- Current command
	local cmd = pane:get_foreground_process_name()
	-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
	cmd = cmd and basename(cmd) or ""

	-- Time
	local time = wezterm.strftime("%l:%M %p")

	-- Right status
	window:set_right_status(wezterm.format({
		-- Wezterm has a built-in nerd fonts
		-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
		{ Text = wezterm.nerdfonts.md_folder .. " " .. cwd },
		{ Text = " | " },
		{ Foreground = { Color = "#e0af68" } },
		{ Text = wezterm.nerdfonts.fa_code .. " " .. cmd },
		"ResetAttributes",
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. " " .. time },
		{ Text = "  " },
	}))
end)
-- Tab bar configuration
local config = {
	show_new_tab_button_in_tab_bar = false,
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,
	tab_max_width = 44,
	colors = {
		tab_bar = {
			background = scheme.background,
		},
	},
}

return config
