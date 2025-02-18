return {
	{
		'saghen/blink.cmp',
		dependencies = {},
		version = '*',

		opts = {
			keymap = { preset = 'default' },

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono'
			},

			signature = {
				enabled = true
			},

			completion = {
				menu = {
					-- nvim-cmp style menu
					draw = {
						treesitter = { 'lsp' },
						columns = {
							{ "kind_icon", "label", "label_description", gap = 1 },

						},
					}
				},
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				ghost_text = { enabled = true },
			},

			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},
		},
		opts_extend = { "sources.default" }
	}
}
