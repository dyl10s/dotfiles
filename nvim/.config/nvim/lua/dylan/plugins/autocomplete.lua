return {
	{
		'saghen/blink.cmp',
		dependencies = {
			'Kaiser-Yang/blink-cmp-avante',
		},
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
					draw = {
						treesitter = { 'lsp' },
						columns = {
							{ "kind_icon", "label", "label_description", gap = 1 },
						},
					}
				},
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				ghost_text = { enabled = false },
			},

			sources = {
				default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
				providers = {
					avante = {
						module = 'blink-cmp-avante',
						name = 'Avante',
						opts = {
							-- options for blink-cmp-avante
						}
					},
				},
			},
		},
		opts_extend = { "sources.default" }
	}
}
