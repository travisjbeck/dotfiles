return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      -- terminal = {
        -- height = 0.6, -- 60% of screen height (default is usually 0.3)
      -- }
    })
  end
}
