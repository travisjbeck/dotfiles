-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.undofile = true

-- turn the bloody swapfiles off
vim.opt.swapfile = false

-- vim.opt.colorcolumn = "120"

-- Set your search preferences
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if you type uppercase

-- turn off whitespace indicators
vim.opt.list = false
