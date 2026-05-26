local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = ""
	}
	vim.lsp.buf.execute_command(params)
end

return {
	{
		"williamboman/mason.nvim",
		tag = "v1.11.0",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"williamboman/mason-lspconfig.nvim",
				tag = "v1.32.0"
			},
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",
			"yioneko/nvim-vtsls",
			"saghen/blink.cmp",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()

			-- Set up lspconfig.
			local capabilities = require('blink.cmp').get_lsp_capabilities()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util")
			local userLspAuGroup = vim.api.nvim_create_augroup('UserLspConfig', {})

			local enableTSGO = false;

			-- gopls managed via go install, not Mason
			vim.lsp.config.gopls = {
				cmd = { "/Users/dylan/go/bin/gopls", "-remote=auto", "-remote.listen.timeout=0" },
				capabilities = capabilities,
				settings = {
					gopls = {
						buildFlags = { "-tags=janitor,evals" },
					},
				},
			}
			vim.lsp.enable("gopls")

			require("mason-lspconfig").setup_handlers {
				function(server_name) -- default handler (optional)
					vim.lsp.config[server_name] = {
						capabilities = capabilities,
					}
					vim.lsp.enable(server_name)
				end,
				["html"] = function()
					vim.lsp.config.html = {
						capabilities = capabilities,
						init_options = {
							provideFormatter = false
						}
					}
					vim.lsp.enable("html")
				end,
				["lua_ls"] = function()
					vim.lsp.config.lua_ls = {
						capabilities = capabilities,
						diagnostics = {
							globals = {
								'vim'
							}
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true)
						}
					}
					vim.lsp.enable("lua_ls")
				end,
				["clangd"] = function()
					vim.lsp.config.clangd = {
						cmd = {
							-- see clangd --help-hidden
							"clangd",
							"--background-index",
							-- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
							-- to add more checks, create .clang-tidy file in the root directory
							-- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
							"--clang-tidy",
							"--completion-style=bundled",
							"--cross-file-rename",
							"--header-insertion=iwyu",
						},
						capabilities = capabilities,
						init_options = {
							clangdFileStatus = true, -- Provides information about activity on clangd’s per-file worker thread
							usePlaceholders = true,
							completeUnimported = true,
							semanticHighlighting = true,
						},
					}
					vim.lsp.enable("clangd")
				end,
				["ts_ls"] = function()
					if enableTSGO then
						vim.lsp.config.ts_ls = {
							cmd = { "tsgo", "--lsp", "-stdio" },
							capabilities = capabilities,
							lint_options = {
								preferences = {
									importModuleSpecifierPreference = 'relative',
									importModuleSpecifierEnding = 'minimal'
								}
							},
							commands = {
								OrganizeImports = {
									organize_imports,
									description = "Organize Imports"
								}
							}
						}
						vim.lsp.enable("ts_ls")
					end
				end,
				["angularls"] = function()
					local function get_probe_dir(root_dir)
						local project_root = vim.fs.dirname(vim.fs.find('node_modules',
							{ path = root_dir, upward = true })[1])

						return project_root and (project_root .. '/node_modules') or ''
					end

					local function get_angular_core_version(root_dir)
						local project_root = vim.fs.dirname(vim.fs.find('node_modules',
							{ path = root_dir, upward = true })[1])

						if not project_root then
							return ''
						end

						local package_json = project_root .. '/package.json'
						if not vim.loop.fs_stat(package_json) then
							return ''
						end

						local contents = io.open(package_json):read '*a'
						local json = vim.json.decode(contents)
						if not json.dependencies then
							return ''
						end

						local angular_core_version = json.dependencies['@angular/core']

						return angular_core_version
					end

					local default_probe_dir = get_probe_dir(vim.fn.getcwd())
					local default_angular_core_version = get_angular_core_version(vim.fn.getcwd())

					vim.lsp.config.angularls = {
						capabilities = capabilities,
						single_file_support = false,
						root_dir = util.root_pattern("nx.json", "angular.json"),
						filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' },
						cmd = {
							'ngserver',
							'--stdio',
							'--tsProbeLocations',
							default_probe_dir,
							'--ngProbeLocations',
							default_probe_dir,
							'--angularCoreVersion',
							default_angular_core_version,
						},
						on_new_config = function(new_config, new_root_dir)
							local new_probe_dir = get_probe_dir(new_root_dir)
							local angular_core_version = get_angular_core_version(new_root_dir)

							-- We need to check our probe directories because they may have changed.
							new_config.cmd = {
								vim.fn.exepath('ngserver'),
								'--stdio',
								'--tsProbeLocations',
								new_probe_dir,
								'--ngProbeLocations',
								new_probe_dir,
								'--angularCoreVersion',
								angular_core_version,
							}
						end,
					}
					vim.lsp.enable("angularls")
				end,
				["vtsls"] = function()
					if not enableTSGO then
						vim.lsp.config.vtsls = {
							settings = {
								complete_function_calls = true,
								experimental = {
									completion = {
										enableServerSideFuzzyMatch = true
									}
								},
								typescript = {
									tsserver = {
										maxTsServerMemory = 8192
									},
									preferences = {
										importModuleSpecifier = "non-relative"
									},
									suggest = {
										completeFunctionCalls = false
									},
									inlayHints = {
										parameterNames = { enabled = "all" },
										includeInlayParameterNameHintsWhenArgumentMatchesName = { enabled = false }
									}
								}
							}
						}
						vim.lsp.enable("vtsls")

						local lsp_vtsls_augroup = vim.api.nvim_create_augroup("lsp-vtsls", { clear = true })

						local vtsls = require("vtsls")
						local adding_imports = false

						vim.api.nvim_create_autocmd("BufWritePost", {
							group = lsp_vtsls_augroup,
							pattern = "*.ts",
							callback = function()
								if adding_imports then return end
								adding_imports = true

								vtsls.commands["add_missing_imports"](0, function()
									if vim.bo.modified then
										vim.cmd("silent write")
									end
									adding_imports = false
								end)
							end,
						})
					end
				end
			}


			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.diagnostic.config({
				float = {
					show_header = false,
					border = 'rounded'
				},
			})

			vim.keymap.set('n', '<space>x', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = userLspAuGroup,
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					local function createBufferBind(mode, keymap, action, desc)
						vim.keymap.set(mode, keymap, action, { buffer = ev.buf, desc = desc })
					end

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					createBufferBind('n', 'gD', vim.lsp.buf.declaration, "Goto declaration")
					createBufferBind('n', 'gd', vim.lsp.buf.definition, "Goto definition")
					createBufferBind('n', 'K', vim.lsp.buf.hover, "Code hover")
					createBufferBind('n', '<leader>cr', vim.lsp.buf.rename, "Rename")
					createBufferBind('n', 'gr', function() require("telescope.builtin").lsp_references() end,
						"Goto references")
					createBufferBind('n', 'gi', vim.lsp.buf.implementation, "Goto implementation")
					createBufferBind('n', '<leader>D', vim.lsp.buf.type_definition, "Type definition")
					createBufferBind('n', '<leader>ca', vim.lsp.buf.code_action, "Code action")
					createBufferBind('n', '<leader>oi', organize_imports, "Organize imports")
					createBufferBind('n', '<leader>f', function()
						vim.lsp.buf.format { async = true }
					end, "Format")
				end,
			})

			-- Restart LSP when git branch changes
			local last_git_head = vim.fn.system("git rev-parse HEAD 2>/dev/null"):gsub("\n", "")
			vim.api.nvim_create_autocmd("FocusGained", {
				group = userLspAuGroup,
				callback = function()
					local git_head = vim.fn.system("git rev-parse HEAD 2>/dev/null"):gsub("\n", "")
					if last_git_head and git_head ~= last_git_head then
						vim.cmd("silent! LspRestart")
						vim.notify("lsp restarted branch change", vim.log.levels.INFO)
					end
					last_git_head = git_head
				end,
			})
		end
	}
}
