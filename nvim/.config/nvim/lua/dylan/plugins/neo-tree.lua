return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	config = function()
		local tree = require("neo-tree")

		tree.setup({
			log_level = "warn",
			filesystem = {
				follow_current_file = {
					enabled = true
				},
				use_libuv_file_watcher = true,
				filtered_items = {
					always_show = {
						".env",
						".example.env"
					}
				}
			},
			buffers = {
				follow_current_file = {
					enabled = true
				}
			},
			window = {
				position = "right",
				mappings = {
					["C"] = {
						function(state)
							local currentPath = state.tree:get_node().path
							vim.ui.input({ prompt = 'Component Name:' }, function(answer)
								if answer then
									vim.cmd(':vsplit | terminal cd ' ..
										currentPath .. ' && nx g @nx/angular:component ' ..
										answer .. ' --skipTests --skipFormat')
									vim.cmd(':startinsert')
								end
							end)
						end
					},
					["X"] = {
						function(state)
							local currentPath = state.tree:get_node().path
							vim.ui.input({ prompt = 'Command:' }, function(answer)
								if answer then
									vim.cmd(':vsplit | terminal cd ' ..
										currentPath .. ' && ' .. answer)
									vim.cmd(':startinsert')
								end
							end)
						end
					}
				}
			}
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.cmd("Neotree show")
			end
		})
	end
}
