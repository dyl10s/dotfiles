vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local ts_compat = {
	parsers_shim = function(mod)
		if not mod.ft_to_lang then
			mod.ft_to_lang = vim.treesitter.language.get_lang
		end
		if not mod.get_buf_lang then
			mod.get_buf_lang = function(bufnr)
				bufnr = bufnr or vim.api.nvim_get_current_buf()
				local ft = vim.bo[bufnr].filetype
				return vim.treesitter.language.get_lang(ft) or ft
			end
		end
		if not mod.get_parser then
			mod.get_parser = function(bufnr, lang)
				bufnr = bufnr or vim.api.nvim_get_current_buf()
				lang = lang or vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
				return vim.treesitter.get_parser(bufnr, lang)
			end
		end
		if not mod.has_parser then
			mod.has_parser = function(lang)
				return pcall(vim.treesitter.language.inspect, lang)
			end
		end
		return mod
	end,
	configs_shim = function(mod)
		if not mod.is_enabled then
			mod.is_enabled = function(_, lang)
				if not lang then return false end
				local ok = pcall(vim.treesitter.language.inspect, lang)
				return ok
			end
		end
		if not mod.get_module then
			mod.get_module = function()
				return { additional_vim_regex_highlighting = false }
			end
		end
		return mod
	end,
	locals_shim = {
		get_definitions = function() return {} end,
		get_local_nodes = function() return {} end,
	},
}

local orig_require = require
_G.require = function(modname)
	if modname == "nvim-treesitter.locals" then
		return ts_compat.locals_shim
	end
	local ok, mod = pcall(orig_require, modname)
	if not ok then return error(mod) end
	if modname == "nvim-treesitter.parsers" and mod then
		return ts_compat.parsers_shim(mod)
	elseif modname == "nvim-treesitter.configs" and mod then
		return ts_compat.configs_shim(mod)
	end
	return mod
end

require 'dylan.settings'
require 'dylan.lazy'
require 'dylan.fileSwapper'
require 'dylan.keymaps'
require 'dylan.autocommands'
