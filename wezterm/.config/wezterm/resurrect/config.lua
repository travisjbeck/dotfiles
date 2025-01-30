-- File: resurrect/config.lua
-- resurrect.wezterm configuration and settings
--
-- This module:
-- * Configures the resurrect.wezterm plugin
-- * Configures event listener configuration (via an additional required file)
-- * Returns wezterm keybinding configuration for resurrect-related actions.
--
-- The main wezterm configuration is then responsible for merging the
-- keybindings with other keybindings, or setting up its own.
-- plugins are stored at ~/Users/Travis/Library/Application Support/wezterm/plugins/

local config = {}
local wezterm = require("wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local act = wezterm.action
local mux = wezterm.mux

-- resurrect.wezterm periodic save every 5 minutes
resurrect.periodic_save({
	interval_seconds = 300,
	save_tabs = true,
	save_windows = true,
	save_workspaces = true,
})

resurrect.set_encryption({
	enable = true,
	method = "/opt/homebrew/bin/age",
	private_key = wezterm.home_dir .. "/.age/resurrect.txt",
	public_key = "age1749r4a5hq6wepxrpqqpfh385swyf9u7rmakawlp5mmulzw979ams23uqlw",
})

wezterm.on("resurrect.save_state.finished", function()
	wezterm.gui.gui_windows()[1]:toast_notification("Session Saved", "", nil, 4000)
end)

-- Save only 5000 lines per pane
resurrect.set_max_nlines(5000)

-- Default keybindings
-- These will need to be merged with the main wezterm keys.
config.keys = {
	{
		-- Save current and window state
		-- See https://github.com/MLFlexer/resurrect.wezterm for options around
		-- saving workspace and window state separately
		key = "S",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(win, pane) -- luacheck: ignore 212
			local state = resurrect.workspace_state.get_workspace_state()
			resurrect.save_state(state)
			resurrect.window_state.save_window_action()
		end),
	},
	{
		-- Load workspace or window state, using a fuzzy finder
		key = "L",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id, label) -- luacheck: ignore 212
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extension

				-- local opts = {
				-- 	window = win:mux_window(),
				-- 	relative = true,
				-- 	restore_text = true,
				-- 	on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				-- }

				-- From https://github.com/MLFlexer/resurrect.wezterm/issues/70#issuecomment-2618667719
				local opts = {
					close_open_tabs = true, -- **THIS IS THE NEW OPTION**
					window = pane:window(), -- **THIS IS ALSO NEEDED**
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					relative = true,
					restore_text = true,
				}

				if type == "workspace" then
					local state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.load_state(id, "window")
					-- opts.tab = win:active_tab()
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
	{
		-- Delete a saved session using a fuzzy finder
		key = "D",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id)
				resurrect.delete_state(id)
			end, {
				title = "Delete State",
				description = "Select session to delete and press Enter = accept, Esc = cancel, / = filter",
				fuzzy_description = "Search session to delete: ",
				is_fuzzy = true,
			})
		end),
	},
	-- Rename current session; analagous to command in tmux
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for session",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
}

return config
