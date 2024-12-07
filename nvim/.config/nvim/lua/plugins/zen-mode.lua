-- Lua
return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
      -- height and width can be:
      -- * an absolute number of cells when > 1
      -- * a percentage of the width / height of the editor when <= 1
      -- * a function that returns the width or the height
      width = 120, -- width of the Zen window
      height = 1, -- height of the Zen window
      -- by default, no options are changed for the Zen window
      -- uncomment any of the options below, or add other vim.wo options you want to apply
      options = {
        -- signcolumn = "no", -- disable signcolumn
        -- number = false, -- disable number column
        -- relativenumber = false, -- disable relative numbers
        -- cursorline = false, -- disable cursorline
        -- cursorcolumn = false, -- disable cursor column
        -- foldcolumn = "0", -- disable fold column
        -- list = false, -- disable whitespace characters
      },
    },
    plugins = {
      -- disable some global vim options (vim.o...)
      -- comment the lines to not apply the options
      options = {
        enabled = true,
        ruler = false, -- disables the ruler text in the cmd line area
        showcmd = false, -- disables the command in the last line of the screen
        -- you may turn on/off statusline in zen mode by setting 'laststatus'
        -- statusline will be shown only if 'laststatus' == 3
        laststatus = 0, -- turn off the statusline in zen mode
      },
      diagnostics = { enabled = false },
      twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
      gitsigns = { enabled = false }, -- disables git signs
      tmux = { enabled = false }, -- disables the tmux statusline
      todo = { enabled = false }, -- if set to "true", todo-comments.nvim highlights will be disabled
    },
    -- callback where you can add custom code when the Zen window opens
    -- Store the diagnostic state
    on_open = function()
      -- Store current diagnostic state
      vim.g.zen_diagnostics_enabled = vim.diagnostic.is_disabled()
      -- Disable diagnostics
      vim.diagnostics.enable(false)
      vim.opt.wrap = true
    end,
    on_close = function()
      -- Restore previous diagnostic state
      if not vim.g.zen_diagnostics_enabled then
        vim.diagnostic.enable()
      end
      vim.opt.wrap = false
    end,
  },
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
  },
}
