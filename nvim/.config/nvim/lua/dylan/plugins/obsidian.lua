return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local obsidian = require("obsidian")
		obsidian.setup({
			workspaces = {
				{
					name = "notes",
					path = "~/Documents/Notes",
				},
			},
			ui = {
				enable = false
			},
			completion = {
				min_chars = 1
			},
			mappings = {
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				}
			}
		})

		vim.keymap.set("n", "<leader>Od", [[:ObsidianToday<CR>]], { desc = "Open daily obsidian note" })
		vim.keymap.set("n", "<leader>Oy", [[:ObsidianYesterday<CR>]], { desc = "Open yesterday's obsidian note" })
		vim.keymap.set("n", "<leader>Os", [[:ObsidianSearch<CR>]], { desc = "Search obsidian notes" })
	end
}
