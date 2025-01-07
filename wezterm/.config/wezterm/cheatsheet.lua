local wezterm = require("wezterm")
local act = wezterm.action

-- Helper function to read file content
local function read_file(path)
	local file = io.open(path, "r")
	if not file then
		return ""
	end
	local content = file:read("*a")
	file:close()
	return content
end

-- Function to split string into lines
local function split_lines(str)
	local lines = {}
	for line in str:gmatch("[^\r\n]+") do
		table.insert(lines, line)
	end
	return lines
end

-- Combine languages and commands into choices
local function get_choices()
	local languages = read_file(wezterm.home_dir .. "/.wezterm-cht-languages")
	local commands = read_file(wezterm.home_dir .. "/.wezterm-cht-command")
	return split_lines(languages .. "\n" .. commands)
end

-- Main cht.sh function
local function cht_sh(window, pane)
	-- First, show selection menu
	wezterm.log_info("cht_sh")
	window:perform_action(act.InputSelector({
		choices = get_choices(),
		action = wezterm.action_callback(function(window, pane, id, selected)
			if not selected then
				return
			end

			-- Now prompt for the query
			window:perform_action(act.PromptInputLine({
				description = "Enter Query: ",
				action = wezterm.action_callback(function(window, pane, line)
					if not line then
						return
					end

					-- Check if selection is a language
					local languages = split_lines(read_file(wezterm.home_dir .. "/.wezterm-cht-languages"))
					local is_language = false
					for _, lang in ipairs(languages) do
						if lang == selected then
							is_language = true
							break
						end
					end

					-- Construct and execute the curl command
					local cmd
					if is_language then
						local query = line:gsub(" ", "+")
						cmd = string.format("curl cht.sh/%s/%s", selected, query)
					else
						cmd = string.format("curl -s cht.sh/%s~%s", selected, line)
					end

					-- Open new window with the result
					window:perform_action(act.SpawnCommandInNewWindow({
						args = { "bash", "-c", cmd .. " | less" },
					}))
				end),
			}))
		end),
	}))
end

return {
	keys = {
		{
			key = "i",
			mods = "LEADER",
			action = wezterm.action_callback(function(window, pane)
				cht_sh(window, pane)
			end),
		},
	},
}
