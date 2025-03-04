vim.keymap.set("n", "<leader><leader>p", '"_dP', { desc = "Paste un-fucker" })

-- Center when moving through the document
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move lines of selected text up and down
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { noremap = true })
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { noremap = true })
vim.keymap.set("i", "<C-j>", "<Esc>:m .+1<CR>==gi", { noremap = true })
vim.keymap.set("i", "<C-k>", "<Esc>:m .-2<CR>==gi", { noremap = true })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true })

-- Add our new LSP keymaps
vim.keymap.set("n", "gh", vim.lsp.buf.hover, { noremap = true, desc = "Hover" })
vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, { noremap = true, desc = "Signature Help" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename variable" })

-- split the current line at the cursor position
vim.keymap.set("n", "K", "i<CR><Esc>", { noremap = true, silent = true, desc = "Break line" })

-- yank to global clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+y')

-- Reveal current file in the finder
vim.keymap.set("n", "<leader>rf", "<cmd>!open -R %<cr>", { desc = "Reveal in Finder" })


-- Change working directory to root directory
vim.keymap.set("n", "<leader>cwd", function()
  local root = require("lazyvim.util").root()
  vim.cmd("cd " .. root)
  -- Notify WezTerm about the directory change
  -- Emit the OSC 7 sequence to update WezTerm's working directory
  local esc = string.char(27)
  local osc_sequence = string.format("%s]7;file://%s%s", esc, vim.fn.hostname(), root)
  io.write(osc_sequence .. esc .. "\\")
  print("Changed directory to: " .. root)
end, { desc = "Change directory to root" })

-- LSP Keymaps
vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
vim.keymap.set("n", "<C-S-k>", vim.lsp.buf.hover, { desc = "Hover Documentation" })

-- Alt backspace to delete the whole word like normally
vim.keymap.set("i", "<M-BS>", "<C-w>", {})

-- Main utils category
vim.keymap.set("n", "<leader>z", "<nop>", { desc = "+utils" })

-- Copy subcategory
vim.keymap.set("n", "<leader>zc", "<nop>", { desc = "+copy" })

-- Keymaps for copying file paths
vim.keymap.set("n", "<leader>zcp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy full Path to clipboard" })

vim.keymap.set("n", "<leader>zcr", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Copy Relative path to clipboard" })

vim.keymap.set("n", "<leader>zcn", function()
  vim.fn.setreg("+", vim.fn.expand("%:t"))
end, { desc = "Copy fileName to clipboard" })

