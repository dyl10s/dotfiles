return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make"
			},
			'nvim-telescope/telescope-ui-select.nvim'
		},
		cmd = "Telescope",
		keys = {
			{ "<leader><leader>", function() require("telescope.builtin").find_files({ path_display = { truncate = 3 } }) end, desc = "Find files" },
			{ "<leader>sg", function() require("telescope.builtin").live_grep() end, desc = "[S]earch [G]rep" },
			{ "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Switch Branch" },
			{ "<leader>sw", function() require("telescope.builtin").grep_string() end, desc = "[S]earch For Current [W]ord" },
			{ "<leader>sr", function() require("telescope.builtin").resume() end, desc = "[S]earch [R]esume" },
			{ "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "[S]earch [H]elp" },
		},
		config = function()
			local actions = require('telescope.actions')

			require("telescope").setup({
				pickers = {
					git_branches = {
						mappings = {
							i = { ["<cr>"] = actions.git_switch_branch },
						},
					},
				},
			})

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")
		end
	}
}
