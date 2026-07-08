return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>Od", "<cmd>ObsidianToday<CR>", desc = "Open daily obsidian note" },
		{ "<leader>Oy", "<cmd>ObsidianYesterday<CR>", desc = "Open yesterday's obsidian note" },
		{ "<leader>Os", "<cmd>ObsidianSearch<CR>", desc = "Search obsidian notes" },
	},
	cmd = { "ObsidianToday", "ObsidianYesterday", "ObsidianSearch", "ObsidianNew", "ObsidianOpen" },
	ft = "markdown",
	config = function()
		local home = os.getenv("HOME")
		local path = home .. "/Documents/Notes"

		local function path_exists(p)
			local f = io.open(p, "r")
			if f then
				f:close()
				return true
			end
			return false
		end

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
	end
}
