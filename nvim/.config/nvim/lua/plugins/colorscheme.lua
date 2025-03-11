return {
  -- Make poimandres the default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "poimandres",
    },
  },

  -- Configure poimandres with custom highlights
  {
    "olivercederborg/poimandres.nvim",
    priority = 1000,
    config = function()
      require("poimandres").setup({
        bold_vert_split = false,
      })

      -- Define all custom highlights once
      local function set_custom_highlights()
        -- Load the actual poimandres palette
        local palette = require("poimandres.palette")

        -- Use palette colors for indent and window separators
        -- Using blueGray for slightly more visibility while staying consistent
        local indent_color = palette.background1
        local scope_color = palette.blue
        local separator_color = palette.background1

        -- Set indent and window separator highlights
        vim.api.nvim_set_hl(0, "IblIndent", { fg = indent_color })
        vim.api.nvim_set_hl(0, "IblScope", { fg = scope_color })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = separator_color })

        -- Comprehensive Neo-tree highlights using the poimandres palette
        -- Base Neo-tree elements
        vim.api.nvim_set_hl(0, "NeoTreeNormal", { fg = palette.text, bg = palette.bg })
        vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { fg = palette.text, bg = palette.bg })
        vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { fg = palette.bg, bg = palette.bg })
        vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { fg = palette.blueGray, bg = palette.bg })
        vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = palette.blueGray, bg = palette.bg })

        local comment_color = "#54576c"
        vim.api.nvim_set_hl(0, "Comment", { fg = comment_color })
        vim.api.nvim_set_hl(0, "LineComment", { fg = comment_color })
        vim.api.nvim_set_hl(0, "DocComment", { fg = comment_color })

        -- Basic UI elements
        vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = palette.selection })
        vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = indent_color })
        vim.api.nvim_set_hl(0, "NeoTreeDotfile", { fg = palette.muted })
        vim.api.nvim_set_hl(0, "NeoTreeHiddenByName", { fg = palette.muted })
        vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = palette.muted })
        vim.api.nvim_set_hl(0, "NeoTreeSymbolicLinkTarget", { fg = palette.blue })

        -- Folders and Files
        vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = palette.white, bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = palette.text })
        vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = palette.blue })
        vim.api.nvim_set_hl(0, "NeoTreeFileNameOpened", { fg = palette.cyan, bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = palette.cyan })
        vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = palette.cyan })
        vim.api.nvim_set_hl(0, "NeoTreeDirectoryNameOpened", { fg = palette.blue, bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeExpander", { fg = palette.muted })
        vim.api.nvim_set_hl(0, "NeoTreeExpanderOpened", { fg = palette.muted })

        -- Git status elements
        vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = palette.green })
        vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = palette.red })
        vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = palette.red })
        vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = palette.yellow })
        vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = palette.yellow })
        vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { fg = palette.orange })
        vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { fg = palette.green })

        -- Floats and popups
        vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { fg = palette.blueGray, bg = palette.bg })
        vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { fg = palette.white, bg = palette.bg })
        vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { fg = palette.white, bg = palette.bg })
        vim.api.nvim_set_hl(0, "NeoTreeWindowsHidden", { fg = palette.muted })
      end

      -- Apply after colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "poimandres",
        callback = set_custom_highlights,
      })

      -- Apply immediately if poimandres is active
      vim.schedule(function()
        if vim.g.colors_name == "poimandres" then
          set_custom_highlights()
        end
      end)
    end,
  },

  -- Ensure indent-blankline.nvim is configured
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
      },
      scope = {
        enabled = true,
      },
    },
  },
}
