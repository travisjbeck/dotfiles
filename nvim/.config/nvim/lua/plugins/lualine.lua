return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local mode_map = {
      NORMAL = "N",
      ["O-PENDING"] = "N?",
      INSERT = "I",
      VISUAL = "V",
      ["V-BLOCK"] = "VB",
      ["V-LINE"] = "VL",
      ["V-REPLACE"] = "VR",
      REPLACE = "R",
      COMMAND = "!",
      SHELL = "SH",
      TERMINAL = "T",
      EX = "X",
      ["S-BLOCK"] = "SB",
      ["S-LINE"] = "SL",
      SELECT = "S",
      CONFIRM = "Y?",
      MORE = "M",
    }
    opts.options.disabled_filetypes = {
      statusline = { "neo-tree", "Neotree" },
      winbar = { "neo-tree", "Neotree" },
    }
    opts.options.globalstatus = false

    local wordCount = {}
    function wordCount.getWords()
      if vim.tbl_contains({ "md", "txt", "markdown" }, vim.bo.filetype) then
        local wc = vim.fn.wordcount()
        if wc.visual_words == 1 then
          return wc.visual_words .. " word"
        elseif wc.visual_words then
          return wc.visual_words .. " words"
        else
          return wc.words .. " words"
        end
      else
        return "Not a text file"
      end
    end

    local function place()
      return string.format("%03d/%03d", vim.fn.line("."), vim.fn.line("$"))
    end

    local function diff_source()
      local g = vim.b.gitsigns_status_dict
      if g then
        return { added = g.added, modified = g.changed, removed = g.removed }
      end
    end

    local function window()
      return vim.api.nvim_win_get_number(0)
    end

    local function show_macro_recording()
      local r = vim.fn.reg_recording()
      return (r == "" and "" or "󰑋  " .. r)
    end

    opts.options.theme = "auto"
    opts.options.component_separators = { " ", " " }
    opts.options.section_separators = { left = "", right = "" }

    opts.sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(s)
            return mode_map[s] or s
          end,
        },
      },
      lualine_b = {
        { "branch", icon = "󰘬" },
        {
          "diff",
          colored = true,
          source = diff_source,
          diff_color = {
            color_added = "#a7c080",
            color_modified = "#ffdf1b",
            color_removed = "#ff6666",
          },
        },
      },
      lualine_c = {
        { "diagnostics", sources = { "nvim_diagnostic" } },
        function()
          return "%="
        end,
        {
          "filename",
          file_status = true,
          path = 1,
          shorting_target = 40,
          symbols = { modified = "󰐖", readonly = "", unnamed = "[No Name]", newfile = "[New]" },
        },
        {
          wordCount.getWords,
          color = { fg = "#333333", bg = "#eeeeee" },
          separator = { left = "", right = "" },
          cond = function()
            return wordCount.getWords() ~= "Not a text file"
          end,
        },
        { "searchcount" },
        { "selectioncount" },
        {
          show_macro_recording,
          color = { fg = "#333333", bg = "#ff6666" },
          separator = { left = "", right = "" },
        },
      },
      lualine_x = {
        {
          "filetype",
          icons = true,
          icon_only = true, -- Show only icon, not the name
          colored = true, -- Colored icon
        },
      },
      lualine_y = { nil },
      lualine_z = { { place, padding = { left = 1, right = 1 } } },
    }

    opts.inactive_sections = {
      lualine_a = { { window, color = { fg = "#26ffbb", bg = "#282828" } } },
      lualine_b = {
        {
          "diff",
          source = diff_source,
          color_added = "#a7c080",
          color_modified = "#ffdf1b",
          color_removed = "#ff6666",
        },
      },
      lualine_c = {
        function()
          return "%="
        end,
        {
          "filename",
          path = 1,
          shorting_target = 40,
          symbols = { modified = "󰐖", readonly = "", unnamed = "[No Name]", newfile = "[New]" },
        },
      },
      lualine_x = { { place, padding = { left = 1, right = 1 } } },
    }

    opts.extensions = { "quickfix", "oil", "fzf" }
    opts.refresh = {
      statusline = 100,
      tabline = 100,
      winrar = 100,
    }

    opts.tabline = {}
    opts.winbar = {}
    opts.inactive_winbar = {}

    vim.api.nvim_create_autocmd("RecordingEnter", {
      callback = function()
        require("lualine").refresh()
      end,
    })
    vim.api.nvim_create_autocmd("RecordingLeave", {
      callback = function()
        local t = vim.loop.new_timer()
        t:start(
          50,
          0,
          vim.schedule_wrap(function()
            require("lualine").refresh()
          end)
        )
      end,
    })
  end,
}
