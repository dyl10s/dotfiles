return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local home = os.getenv("HOME")
		local path = home .. "/Documents/Notes"

		-- Function to check if a path exists
		local function path_exists(p)
			local f = io.open(p, "r")
			if f then
				f:close()
				return true
			end
			return false
		end

		-- Create the directory if it doesn't exist
		if not path_exists(path) then
			os.execute("mkdir -p " .. path)
		end

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
