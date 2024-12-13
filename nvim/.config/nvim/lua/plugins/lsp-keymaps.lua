-- LSP keymaps
return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- disable a keymap
    keys[#keys + 1] = { "K", false }
    -- Set rename options
    opts.rename_with_preview = true
    opts.rename_popup = true

    return opts -- Don't forget to return the modified opts
  end,
}
