-- Pull in the wezterm API
local wezterm = require("wezterm")
require("on")
require("tabbar")

-- config.color_scheme = "Tokyo Night Moon"
-- config.color_scheme = "Poimandres"
local schemeName = "Tokyo Night"
local scheme = wezterm.get_builtin_color_schemes()[schemeName]

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action
-- This is where you actually apply your config choices

-- change leader key

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

config.exit_behavior = "CloseOnCleanExit"
config.window_close_confirmation = "AlwaysPrompt"

config.scrollback_lines = 3000
config.default_workspace = "main"

-- dim inactive pane
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}
config.default_cwd = "~/Developer"
config.window_decorations = "RESIZE"
config.color_scheme = schemeName

config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}

config.keys = {
	-- Disable Ctrl-D by making it do nothing
	{
		key = "d",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},

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
}

-- tab bar configuration
config.show_new_tab_button_in_tab_bar = false

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
-- and finally, return the configuration to wezterm
return config
