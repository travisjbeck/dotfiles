-- Pull in the wezterm API
local wezterm = require("wezterm")
local merge = require("merge")
local resurrect = require("resurrect/config")

require("tabbar")

-- config.color_scheme = "Tokyo Night Moon"
-- config.color_scheme = "Poimandres"
local schemeName = "Tokyo Night"
local scheme = wezterm.get_builtin_color_schemes()[schemeName]

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

-- change leader key
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1500 }

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 17

config.exit_behavior = "CloseOnCleanExit"
config.window_close_confirmation = "AlwaysPrompt"

config.scrollback_lines = 3000
config.default_workspace = "Travis"

-- dim inactive pane
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

config.mouse_bindings = {
	-- Open URLs with Ctrl+Click
	{ event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL", action = act.OpenLinkAtMouseCursor },
}

-- config.default_cwd = "~/Developer"
config.window_decorations = "RESIZE"
config.color_scheme = schemeName

--sessions and workspaces
config.unix_domains = {
	{
		name = "unix",
	},
}

config.window_background_opacity = 1
config.macos_window_background_blur = 10

config.window_padding = {
	left = 20,
	right = 15,
	top = 20,
	bottom = 20,
}
config.line_height = 1.0

config.keys = {
	-- Disable Ctrl-D by making it do nothing
	{
		key = "d",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	-- Allow CMD-a to work
	{
		key = "a",
		mods = "CMD",
		action = wezterm.action.SendKey({
			key = "a",
			mods = "CMD",
		}),
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
	-- Attach to muxer
	{
		key = "a",
		mods = "LEADER",
		action = act.AttachDomain("unix"),
	},

	-- Detach from muxer
	{
		key = "d",
		mods = "LEADER",
		action = act.DetachDomain({ DomainName = "unix" }),
	},

	-- Show list of workspaces
	{
		key = "s",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
}

--allow cmd keys to get through to nvim
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
-- tab bar configuration
config.show_new_tab_button_in_tab_bar = false

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

config.tab_max_width = 40

config.keys = merge.all(config.keys, resurrect.keys)

-- nvim zen mode integration to increase the font size
-- https://github.com/folke/zen-mode.nvim?tab=readme-ov-file#-plugins

-- 	local overrides = window:get_config_overrides() or {}
-- 	wezterm.log_info("user var changed")
-- 	if name == "ZEN_MODE" then
-- 		local incremental = value:find("+")
-- 		local number_value = tonumber(value)
-- 		if incremental ~= nil then
-- 			while number_value > 0 do
-- 				window:perform_action(wezterm.action.IncreaseFontSize, pane)
-- 				number_value = number_value - 1
-- 			end
-- 			overrides.enable_tab_bar = false
-- 		elseif number_value < 0 then
-- 			window:perform_action(wezterm.action.ResetFontSize, pane)
-- 			overrides.font_size = nil
-- 			overrides.enable_tab_bar = true
-- 		else
-- 			overrides.font_size = number_value
-- 			overrides.enable_tab_bar = false
-- 		end
-- 	end
-- 	window:set_config_overrides(overrides)
-- end)

-- and finally, return the configuration to wezterm
return config
