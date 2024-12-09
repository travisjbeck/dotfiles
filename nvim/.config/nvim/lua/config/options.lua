-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.undofile = true

-- vim.opt.hlsearch = false
-- vim.opt.incsearch = true

-- Set minimum number of lines to keep above and below the cursor
vim.opt.scrolloff = 16

-- vim.opt.colorcolumn = "120"
