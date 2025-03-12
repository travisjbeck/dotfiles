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

      -- Define Neo-Tree highlights using Poimandres colors
      local function setup_neotree_highlights()
        local utils = require("poimandres.utils")
        local palette = require("poimandres.palette")

        -- Create properly darkened background
        local dark_bg = palette.background3

        -- Create a better highlight background with more contrast for text
        local highlight_bg = utils.blend(palette.background1, palette.blue4, 0.4)

        -- Define Neo-Tree highlight groups
        local highlights = {
          -- File path at top should be bright
          NeoTreeRootName = { fg = palette.teal1, bold = true },

          -- Current path should be bright - these are the "open folders"
          NeoTreeDirectoryIcon = { fg = palette.blue1 },
          NeoTreeDirectoryName = { fg = palette.muted},

          -- Normal files should be dim
          NeoTreeFileIcon = { fg = palette.blueGray3 },
          NeoTreeFileName = { fg = palette.blueGray2 },

          -- Selected item should be bright with HIGH CONTRAST
          NeoTreeCursorLine = { bg = palette.background1 },
          NeoTreeCursor = { fg = "#FFFFFF", bold = true }, -- Bright white for maximum contrast

          -- Make utility elements dim
          NeoTreeIndentMarker = { fg = palette.blueGray3 },
          NeoTreeExpander = { fg = palette.blueGray3 },
          NeoTreeDimText = { fg = palette.blueGray3 },

          -- Git status indicators - high visibility versions
          NeoTreeGitModified = { fg = palette.yellow },
          NeoTreeGitStaged = { fg = palette.teal1 },
          NeoTreeGitUntracked = { fg = palette.pink3 },

          -- Make git status stand out in the cursor line too
          NeoTreeGitModifiedCursor = { fg = "#FFFF00", bold = true }, -- Bright yellow
          NeoTreeGitStagedCursor = { fg = "#00FFAA", bold = true }, -- Bright teal
          NeoTreeGitUntrackedCursor = { fg = "#FF80FF", bold = true }, -- Bright pink

          -- Background and containers
          NeoTreeNormal = { fg = palette.blueGray2, bg = dark_bg },
          NeoTreeNormalNC = { fg = palette.blueGray2, bg = dark_bg },
          NeoTreeFloatBorder = { fg = palette.blueGray3, bg = dark_bg },
          NeoTreeFloatTitle = { fg = palette.text, bg = dark_bg },
          NeoTreeFloatNormal = { bg = dark_bg },

          -- Tabs
          NeoTreeTabActive = { fg = palette.teal1, bg = palette.background1, bold = true },
          NeoTreeTabInactive = { fg = palette.blueGray3, bg = dark_bg },
          NeoTreeTabSeparatorActive = { fg = palette.teal1, bg = palette.background1 },
          NeoTreeTabSeparatorInactive = { fg = palette.background2, bg = dark_bg },

          -- Additional elements
          NeoTreeStatus = { fg = palette.blueGray3 },
          NeoTreeSymbolicLinkTarget = { fg = palette.blueGray3 },

          -- CRITICAL: Special highlighting for opened files and directories
          NeoTreeTitleBar = { fg = palette.text, bold = true },
          NeoTreeWindowsHidden = { fg = palette.blueGray3 },

          -- CRITICAL: Make the file path at the top bright
          NeoTreeMessage = { fg = palette.text },
          NeoTreePathActive = { fg = palette.text, bold = true },
        }

        -- Apply the highlights
        for group, color in pairs(highlights) do
          utils.highlight(group, color)
        end

        -- EXTRA: Add specific support for marking the current file with extra brightness
        vim.api.nvim_set_hl(0, "NeoTreeFileNameOpened", { fg = palette.text, bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeBufferNumber", { fg = palette.teal1 })
      end

      -- Define all custom highlights once
      local function set_custom_highlights()
        -- Load the actual poimandres palette
        local palette = require("poimandres.palette")
        -- Use palette colors for indent and window separators
        -- Using blueGray for slightly more visibility while staying consistent
        local indent_color = palette.background1
        local scope_color = palette.blue1
        local separator_color = palette.background1
        -- Set indent and window separator highlights
        vim.api.nvim_set_hl(0, "IblIndent", { fg = indent_color })
        vim.api.nvim_set_hl(0, "IblScope", { fg = scope_color })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = separator_color })
        local comment_color = "#54576c"
        vim.api.nvim_set_hl(0, "Comment", { fg = comment_color })
        vim.api.nvim_set_hl(0, "LineComment", { fg = comment_color })
        vim.api.nvim_set_hl(0, "DocComment", { fg = comment_color })

        -- Apply Neo-Tree highlights
        setup_neotree_highlights()
      end

      -- Apply after colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*", -- Changed to trigger on any colorscheme
        callback = set_custom_highlights,
      })

      -- Apply immediately if poimandres is active
      vim.schedule(function()
        set_custom_highlights() -- Changed to always apply, not just for poimandres
      end)
    end,
  },
}
