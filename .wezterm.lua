local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 18
config.hide_tab_bar_if_only_one_tab = true

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

return config
