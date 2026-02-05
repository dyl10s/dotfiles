return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			local conform = require("conform")
			local cwd = vim.loop.cwd()
			local formatters = {
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				yml = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				scss = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				cpp = { "clang-format", stop_after_first = true },
				cc = { "clang-format", stop_after_first = true },
				h = { "clang-format", stop_after_first = true }
			}

			if cwd:match("typescript%-go") then
				formatters.typescript = { "dprint", stop_after_first = true }
				formatters.typescriptreact = { "dprint", stop_after_first = true }
				formatters.javascript = { "dprint", stop_after_first = true }
				formatters.javascriptreact = { "dprint", stop_after_first = true }
			end

			conform.setup({
				formatters_by_ft = formatters,
				format_after_save = {
					lsp_format = "fallback",
					async = true,
					callback = function()
						vim.notify("Format done")
					end
				}
			})
		end
	}
}
