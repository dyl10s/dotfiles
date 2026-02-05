return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon: Add file" },
			{ "<C-e>", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end, desc = "Harpoon: Menu" },
			{ "<C-j>", function() require("harpoon"):list():select(1) end, desc = "Harpoon: File 1" },
			{ "<C-k>", function() require("harpoon"):list():select(2) end, desc = "Harpoon: File 2" },
			{ "<C-l>", function() require("harpoon"):list():select(3) end, desc = "Harpoon: File 3" },
			{ "<C-;>", function() require("harpoon"):list():select(4) end, desc = "Harpoon: File 4" },
		},
		config = function()
			require("harpoon"):setup()
		end
	}
}
