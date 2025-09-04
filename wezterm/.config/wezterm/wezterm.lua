-- Pull in the wezterm API
local wezterm = require("wezterm")
require("tabbar")
require("cheatsheet")

local resurrectConfig = require("resurrect/config")
local merge = require("merge")

-- keep plugins updated
-- wezterm.plugin.update_all()

local schemeName = "Tokyo Night"

local config = {

	font = wezterm.font("MesloLGS Nerd Font Mono"),
	font_size = 16,

	exit_behavior = "CloseOnCleanExit",
	window_close_confirmation = "AlwaysPrompt",

	scrollback_lines = 3000,
	default_workspace = "Travis",

	-- dim inactive pane
	inactive_pane_hsb = {
		saturation = 0.7,
		brightness = 0.7,
	},

	-- config.default_cwd = "~/Developer"
	window_decorations = "RESIZE",
	color_scheme = schemeName,

	status_update_interval = 1000,

	window_background_opacity = 1,
	macos_window_background_blur = 10,

	window_padding = {
		left = 5,
		right = 0,
		top = 5,
		bottom = 0,
	},

	-- Workaround for freezing issues with long-running processes
	front_end = "OpenGL",
	-- config.line_height = 1.0

	--allow cmd keys to get through to nvim
	-- send_composed_key_when_left_alt_is_pressed = false,
	-- send_composed_key_when_right_alt_is_pressed = false,
	-- tab bar configuration
	show_new_tab_button_in_tab_bar = false,

	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = false,

	tab_max_width = 40,
}

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1500 } -- CTRL+b, also like tmux

config.keys = require("keybinds")

-- Import other keys from separate configs to keep the code organized
config.keys = merge.all(config.keys, resurrectConfig.keys)
config.mouse_bindings = require("mousebinds")

-- nvim zen mode integration to increase the font size
-- https://github.com/folke/zen-mode.nvim?tab=readme-ov-file#-plugins
wezterm.on("user-var-changed", function(window, pane, name, value)
	wezterm.log_info("user var changed" .. name)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
