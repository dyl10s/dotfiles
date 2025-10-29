return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		-- Recommended for `ask()` and `select()`.
		-- Required for `toggle()`.
		{ "folke/snacks.nvim", opts = { input = {}, picker = {} } },
	},
	config = function()
		vim.g.opencode_opts = {
			-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on `opencode_opts`.
		}

		-- Required for `vim.g.opencode_opts.auto_reload`.
		vim.o.autoread = true

		-- Recommended/example keymaps.
		local keymaps = {
			{
				modes = { "n", "x" },
				key = "<leader>oa",
				func = function() require("opencode").ask("@this: ", { submit = true }) end,
				desc = "🤖 Ask about this"
			},
			{
				modes = { "n", "x" },
				key = "<leader>os",
				func = function() require("opencode").select() end,
				desc = "🤖 Select prompt"
			},
			{
				modes = { "n", "x" },
				key = "<leader>o+",
				func = function() require("opencode").prompt("@this") end,
				desc = "🤖 Add this"
			},
			{
				modes = "n",
				key = "<leader>ot",
				func = function() require("opencode").toggle() end,
				desc = "🤖 Toggle embedded"
			},
			{
				modes = "n",
				key = "<leader>oc",
				func = function() require("opencode").command() end,
				desc = "🤖 Select command"
			},
			{
				modes = "n",
				key = "<leader>on",
				func = function() require("opencode").command("session_new") end,
				desc = "🤖 New session"
			},
			{
				modes = "n",
				key = "<leader>oi",
				func = function() require("opencode").command("session_interrupt") end,
				desc = "🤖 Interrupt session"
			},
			{
				modes = "n",
				key = "<leader>oA",
				func = function() require("opencode").command("agent_cycle") end,
				desc = "🤖 Cycle selected agent"
			},
			{
				modes = "n",
				key = "<S-C-u>",
				func = function() require("opencode").command("messages_half_page_up") end,
				desc = "🤖 Messages half page up"
			},
			{
				modes = "n",
				key = "<S-C-d>",
				func = function() require("opencode").command("messages_half_page_down") end,
				desc = "🤖 Messages half page down"
			},
		}
		for _, km in ipairs(keymaps) do
			vim.keymap.set(km.modes, km.key, km.func, { desc = km.desc })
		end
	end,
}
