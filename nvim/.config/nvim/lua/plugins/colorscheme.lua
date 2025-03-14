return {
  -- Configure colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
  
  -- Add the tokyonight plugin if not already installed
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000, -- Load this before all other plugins
    opts = {
      style = "night", -- Options: "storm", "moon", "night", "day"
    },
  },
}
