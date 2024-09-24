-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'catppuccin-frappe'

-- Set tmux as default
config.default_prog = { 'tmux' }

-- Set font
config.font = wezterm.font 'CaskaydiaCove Nerd Font Mono'

-- Window looks
config.enable_tab_bar = false;
config.window_padding = {
	left = 3,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_background_opacity = 0.95
config.font_size = 18

-- and finally, return the configuration to wezterm
return config
