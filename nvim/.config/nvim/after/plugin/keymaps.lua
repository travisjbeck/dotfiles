vim.keymap.set("n", "<leader><leader>p", '"_dP', { desc = "Paste un-fucker" })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { noremap = true })
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { noremap = true })
vim.keymap.set("i", "<C-j>", "<Esc>:m .+1<CR>==gi", { noremap = true })
vim.keymap.set("i", "<C-k>", "<Esc>:m .-2<CR>==gi", { noremap = true })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true })
-- split the current line at the cursor position
vim.keymap.set("n", "K", "i<CR><Esc>", { noremap = true, silent = true, desc = "Break line" })
vim.keymap.set("n", "gh", vim.lsp.buf.hover, { noremap = true })

-- yank to global clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+y')

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
