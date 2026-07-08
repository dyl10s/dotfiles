return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"fredrikaverpil/neotest-golang",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-jest",
	},
	event = "VeryLazy",
	keys = {
		{ "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
		{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File Tests" },
		{ "<leader>ts", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Tests" },
		{ "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last Test" },
		{ "<leader>tt", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary" },
		{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Test Output" },
		{ "<leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
		{ "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop Tests" },

	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-golang")({
					warn_test_name_dupes = false,
				}),
				require("neotest-vitest"),
				require("neotest-jest"),
			},
		})
	end,
}
