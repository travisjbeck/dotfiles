local wezterm = require("wezterm")
local schemeName = "Poimandres"
local scheme = wezterm.get_builtin_color_schemes()[schemeName]

-- Define the separator characters
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
local RIGHT_ARROW = wezterm.nerdfonts.pl_left_soft_divider

-- Tab title function
local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- Use your Tokyo Night colors
	local edge_background = scheme.background
	local background = scheme.background
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
	-- Add tab index for non-active tabs
	if not tab.is_active then
		title = tab.tab_index + 1 .. ": " .. title
	end
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
end)

wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	-- Figure out the cwd and host of the current pane.
	-- This will pick up the hostname for the remote host if your
	-- shell is using OSC 7 on the remote host.
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		local cwd = ""
		local hostname = ""

		cwd = cwd_uri.file_path
		hostname = cwd_uri.host or wezterm.hostname()
		-- Remove the domain name portion of the hostname
		local dot = hostname:find("[.]")
		if dot then
			hostname = hostname:sub(1, dot - 1)
		end
		if hostname == "" then
			hostname = wezterm.hostname()
		end

		cwd = string.gsub(cwd, "^/Users/Travis/", "~/")

		table.insert(cells, cwd)
	end

	-- I like my date/time in this style: "Wed Mar 3 08:14"
	local date = wezterm.strftime("%a %b %-d ")
	table.insert(cells, date)

	-- An entry for each battery (typically 0 or 1 battery)
	for _, b in ipairs(wezterm.battery_info()) do
		table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
	end

	local base = wezterm.color.parse(scheme.brights[1])
	base = base:lighten(0.2)
	local colors = {
		base:darken(0.6), -- darkest (30% darker)
		base:darken(0.4), -- 20% darker
		base:darken(0.2), -- 10% darker
		base, -- original color
	}

	-- Foreground color for the text across the fade
	local text_fg = scheme.foreground

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	local function push(text, is_last)
		local cell_no = num_cells + 1

		if cell_no == 1 then
			table.insert(elements, { Background = { Color = scheme.background } })
			table.insert(elements, { Foreground = { Color = colors[1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end

		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)
