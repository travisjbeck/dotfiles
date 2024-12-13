return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Keymap modifications
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = { "K", false }

    -- Custom hover handler
    vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
      config = config
        or {
          border = {
            { "╭", "Comment" },
            { "─", "Comment" },
            { "╮", "Comment" },
            { "│", "Comment" },
            { "╯", "Comment" },
            { "─", "Comment" },
            { "╰", "Comment" },
            { "│", "Comment" },
          },
        }
      config.focus_id = ctx.method
      if not (result and result.contents) then
        return
      end
      local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
      if vim.tbl_isempty(markdown_lines) then
        return
      end
      return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
    end

    -- Server configurations
    opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
      vtsls = {
        settings = {
          typescript = {
            inlayHints = {
              enumMemberValues = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              parameterNames = { enabled = false },
              parameterTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              variableTypes = { enabled = false },
            },
          },
        },
      },
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = false,
              parameterNames = false,
              rangeVariableTypes = false,
            },
          },
        },
      },
      pyright = {
        settings = {
          python = {
            analysis = {
              django = true,
            },
          },
        },
      },
    })

    return opts
  end,
}
