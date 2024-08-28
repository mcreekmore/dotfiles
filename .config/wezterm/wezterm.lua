local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action
local launch_menu = {}

config = {
	color_scheme = "Catppuccin Mocha",
	font = wezterm.font("Hack Nerd Font Mono", { weight = "Regular" }),
	font_size = 18,
	hide_tab_bar_if_only_one_tab = true,
	scrollback_lines = 10000,
	use_fancy_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	adjust_window_size_when_changing_font_size = false,
	enable_tab_bar = true,
	window_decorations = "RESIZE",
}

config.keys = {
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
}

config.ssh_domains = {
	{
		name = "unraid",
		remote_address = "192.168.1.207",
		username = "root",
	},
}

config.wsl_domains = {
	{
		name = "WSL:Ubuntu",
		distribution = "Ubuntu",
		username = "matt",
		default_cwd = "/home/matt",
	},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_domain = "WSL:Ubuntu"
	config.font_size = 12
	config.window:set_inner_size(100, 100)

	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "powershell.exe", "-NoLogo" },
	})
end

return config
