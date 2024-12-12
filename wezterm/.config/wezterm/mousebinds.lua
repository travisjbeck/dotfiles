local wezterm = require("wezterm")

return {
	{
		event = { Down = { streak = 4, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
	},

	{ event = { Up = { streak = 1, button = "Left" } }, mods = "CTRL", action = wezterm.action.OpenLinkAtMouseCursor },
}
