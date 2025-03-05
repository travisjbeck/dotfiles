return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      injected = { options = { ignore_errors = true } },
      prettier = {
        prepend_args = {
          "--print-width",
          "1000",
          "--prose-wrap",
          "never",
          "--preserve-newlines",
          "--no-bracket-spacing",
          "--selector-separator-newline=false",
          "--bracket-same-line",
          "true",
          "--single-attribute-per-line=false",
          "--css-declaration-block-single-line",
        },
      },
    },
    formatters_by_ft = {
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
    },
  },
}
