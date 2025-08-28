local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
	-- Split pane creation
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- Pane navigation with Leader (Colemak-DH: m=left, n=down, e=up, i=right)
	{
		key = "m",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "e",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "i",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	-- Pane resizing with Leader+Shift
	{
		key = "m",
		mods = "LEADER|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "n",
		mods = "LEADER|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "e",
		mods = "LEADER|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "i",
		mods = "LEADER|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	-- Pane management
	{
		key = "z",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
	{
		key = "Space",
		mods = "LEADER",
		action = act.RotatePanes("Clockwise"),
	},
	{
		key = "0",
		mods = "LEADER",
		action = act.PaneSelect({
			mode = "Activate",
		}),
	},
	{
		key = "q",
		mods = "LEADER",
		action = act.PaneSelect({
			show_pane_ids = true,
		}),
	},
	{
		key = "c",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	-- open lazygit in a new tab
	{
		key = "g",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local current_tab_id = pane:tab():tab_id()
			local cmd = "lazygit ; wezterm cli activate-tab --tab-id " .. current_tab_id .. " ; exit\n"
			local tab, tab_pane, _ = window:mux_window():spawn_tab({})
			tab_pane:send_text(cmd)
			tab:set_title(wezterm.nerdfonts.dev_git .. " Lazygit")
		end),
	},
	-- Disable Ctrl-D by making it do nothing
	{
		key = "d",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	-- create new named workspace
	{
		key = "w",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	--set current tab name
	{
		key = "t",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter tab name",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Swap current pane with selected pane
	{
		key = "s",
		mods = "LEADER",
		action = act.PaneSelect({ mode = "SwapWithActive" }),
	},
	-- Show list of workspaces
	{
		key = "W",
		mods = "LEADER|SHIFT",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	-- Fix standard backspace to send ^? instead of ^H
	-- { key = "Backspace", mods = "NONE", action = wezterm.action.SendString("\x7f") },
	-- Fix Delete key behavior
	{ key = "Delete", mods = "NONE", action = wezterm.action.SendString("\x1b[3~") },
	-- Fix Ctrl+Backspace for word deletion
	{ key = "Backspace", mods = "CTRL", action = wezterm.action.SendString("\x17") },
}

return keys
