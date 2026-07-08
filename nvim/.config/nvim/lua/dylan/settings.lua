vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.wo.number = true

vim.o.mouse = 'a'

vim.o.clipboard = 'unnamedplus'

vim.o.breakindent = true

vim.o.undofile = true
-- Defender hammers nvim state files; ~/git is excluded, so redirect there.
vim.o.undodir = vim.fn.expand('~/git/nvim-state/undo')
vim.o.shadafile = vim.fn.expand('~/git/nvim-state/shada/main.shada')
vim.o.autoindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

vim.o.relativenumber = true

vim.o.scrolloff = 8

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.opt.swapfile = false

-- Mac windows defender gets a little upset scanning this file all the time
vim.lsp.log.set_level("ERROR")
