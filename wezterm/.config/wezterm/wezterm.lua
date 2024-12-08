-- Pull in the wezterm API
local wezterm = require("wezterm")
require("on")

-- config.color_scheme = "Tokyo Night Moon"
-- config.color_scheme = "Poimandres"
local schemeName = "Tokyo Night"
local scheme = wezterm.get_builtin_color_schemes()[schemeName]

-- Allow neovim zen mode to change the font size
wezterm.on("user-var-changed", function(window, pane, name, value)
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

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

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
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- tab bar configuration
config.show_new_tab_button_in_tab_bar = false

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.colors = {
	tab_bar = {
		background = scheme.background,
		new_tab = { bg_color = "#2e3440", fg_color = scheme.ansi[8], intensity = "Bold" },
		new_tab_hover = { bg_color = scheme.ansi[1], fg_color = scheme.brights[8], intensity = "Bold" },
		-- format-tab-title

		inactive_tab = { bg_color = scheme.background, fg_color = "#FCE8C3" },
		inactive_tab_hover = { bg_color = scheme.ansi[1], fg_color = "#FCE8C3" },
	},
}

-- and finally, return the configuration to wezterm
return config
