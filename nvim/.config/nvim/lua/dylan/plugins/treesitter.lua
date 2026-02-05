return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			vim.filetype.add({
				extension = {
					hbs = "html"
				}
			})

			vim.filetype.add({
				pattern = {
					[".*%.component%.html"] = "htmlangular",
				},
			})

			configs.setup({
				ensure_installed = { "typescript", "lua", "javascript", "html", "angular", "sql" },
				sync_install = false,
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
				modules = {},
				ignore_install = {}
			})
		end
	},
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	}
}
