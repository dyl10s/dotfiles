return {
	-- dir = "~/repos/tweet.nvim",
	-- dev = true,
	lazy = false,
	'dyl10s/tweet.nvim',
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>T", "<cmd>Tweet<cr>", desc = "Send Tweet"
		}
	},
	opts = {
		auto_auth = false
	},
}
