-- -- add more treesitter parsers
-- return {
--   "nvim-treesitter/nvim-treesitter",
--   opts = function(_, opts)
--     opts.incremental_selection = {
--       enable = true,
--       keymaps = {
--         init_selection = "<CR>",
--         node_incremental = "<CR>",
--         scope_incremental = false,
--         node_decremental = "<bs>",
--       },
--     }
--     opts.ensure_installed = {
--       "javascript",
--       "html",
--       "tsx",
--     }
--     -- This is the important part for HTML in JS literals
--     opts.injections = { enable = true }
--   end,
-- }

-- add more treesitter parsers
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    }

    -- Ensure these languages are installed
    opts.ensure_installed = opts.ensure_installed or {}
    vim.list_extend(opts.ensure_installed, {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
    })

    -- Make sure highlight is enabled
    opts.highlight = { enable = true }

    -- Enable injections explicitly
    opts.injections = { enable = true }

    return opts
  end,
}
