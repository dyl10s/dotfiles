return {
	'mfussenegger/nvim-dap',
	dependencies = {
		'leoluz/nvim-dap-go',
		{
			'rcarriga/nvim-dap-ui',
			dependencies = { 'nvim-neotest/nvim-nio' },
		},
	},
	keys = {
		{ "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
		{ "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
		{ "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
		{ "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
		{ "<Leader>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
		{ "<Leader>dr", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Enable dap logging (optional)
		dap.set_log_level("TRACE")

		-- Setup UI
		dapui.setup()

		-- Auto open/close dap-ui
		dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
		dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
		dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

		-- Go adapter
		dap.adapters.go = function(callback, _)
			callback({
				type = "server",
				host = "127.0.0.1",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			})
		end

		-- Go configurations
		local cwd = vim.fn.getcwd()
		print(cwd)
		dap.configurations.go = {
			{
				name = "Bindplane Enterprise (debug)",
				type = "go",
				request = "launch",
				mode = "debug", -- fixed
				program = cwd .. "/cmd/bindplane",
				buildFlags = "-ldflags=-X 'github.com/observiq/bindplane-op-enterprise/version.buildTime=" ..
					os.date("!%Y-%m-%dT%H:%M:%S") .. ".000000000Z'",
				args = {
					"serve",
					"--force-console-color",
					"--env", "development",
					"--accept-eula",
					"--logging-level", "debug",
					"--analytics-disabled",
				},
			},
			{
				name = "Bindplane Enterprise (test package)",
				type = "go",
				request = "launch",
				mode = "test",
				program = cwd .. "/cmd/bindplane",
			},
			{
				name = "Debug current file",
				type = "go",
				request = "launch",
				mode = "debug",
				program = "${file}",
			},
			{
				name = "Test current package",
				type = "go",
				request = "launch",
				mode = "test",
				program = "${fileDirname}",
			},
		}
	end
}
