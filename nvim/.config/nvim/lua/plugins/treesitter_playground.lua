return {
  {
    "nvim-treesitter/playground",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "TSPlaygroundToggle",
    config = function()
      require("nvim-treesitter.configs").setup({
        playground = { enable = true },
      })
    end,
  },
}

