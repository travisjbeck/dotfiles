local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
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
	-- Show list of workspaces
	{
		key = "s",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
}

return keys
