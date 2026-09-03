return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()

			vim.filetype.add({
				extension = {
					hbs = "html"
				}
			})

			vim.filetype.add({
				pattern = {
					[".*%.component%.html"] = "htmlangular",
					[".*/bindplane%-op%-enterprise/resources/.*%.yaml"] = "helm",
				},
			})

			require("nvim-treesitter").install({
				"bash", "csv", "dockerfile", "dtd", "git_rebase", "gitcommit", "gitignore",
				"go", "gomod", "gosum", "gowork", "gotmpl", "graphql", "helm", "html", "javascript", "jinja",
				"jinja_inline", "json", "lua", "make", "pem", "sql", "toml", "tsv", "tsx",
				"typescript", "xml", "yaml", "zsh",
			})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft) or ft
					if not pcall(vim.treesitter.start, args.buf) then
						local installed = require("nvim-treesitter").get_installed()
						local available = require("nvim-treesitter").get_available()
						if not vim.tbl_contains(installed, lang) and vim.tbl_contains(available, lang) then
							require("nvim-treesitter").install({ lang })
						end
					end
				end
			})
		end
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
}
