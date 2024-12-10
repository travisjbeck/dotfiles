-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.undofile = true

-- vim.opt.hlsearch = false
-- vim.opt.incsearch = true

-- vim.opt.colorcolumn = "120"
vim.opt.title = true -- Allows neovom to send the Terminal details of the current window, instead of just getting 'v'
