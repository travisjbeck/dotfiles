-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
require("tabbar")

local schemeName = "Tokyo Night"
local scheme = wezterm.get_builtin_color_schemes()[schemeName]

local config = {

	font = wezterm.font("MesloLGS Nerd Font Mono"),
	font_size = 17,

	exit_behavior = "CloseOnCleanExit",
	window_close_confirmation = "AlwaysPrompt",

	scrollback_lines = 3000,
	default_workspace = "Travis",

	-- dim inactive pane
	inactive_pane_hsb = {
		saturation = 0.24,
		brightness = 0.5,
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
config.mouse_bindings = require("mousebinds")

--ressurect settings
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.periodic_save()
resurrect.set_encryption({
	enable = true,
	method = "/opt/homebrew/bin/age",
	private_key = wezterm.home_dir .. "/.age/resurrect.txt",
	public_key = "age1749r4a5hq6wepxrpqqpfh385swyf9u7rmakawlp5mmulzw979ams23uqlw",
})

local resurrect_event_listeners = {
	"resurrect.error",
	"resurrect.save_state.finished",
}

local is_periodic_save = false

wezterm.on("resurrect.periodic_save", function()
	is_periodic_save = true
end)

for _, event in ipairs(resurrect_event_listeners) do
	wezterm.on(event, function(...)
		if event == "resurrect.save_state.finished" and is_periodic_save then
			is_periodic_save = false
			return
		end
		local args = { ... }
		local msg = event
		-- this adds the save location to the notification. It's a bit much
		-- for _, v in ipairs(args) do
		-- 	wezterm.log_info(v)
		-- 	msg = msg .. " " .. tostring(v)
		-- end
		wezterm.gui.gui_windows()[1]:toast_notification("Wezterm - resurrect", msg, nil, 4000)
	end)
end

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
