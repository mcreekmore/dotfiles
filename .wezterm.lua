local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 18

config.ssh_domains = {
	{
		name = "unraid",
		remote_address = "192.168.1.207",
		username = "root",
	},
}

return config
