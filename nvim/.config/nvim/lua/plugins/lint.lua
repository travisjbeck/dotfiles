return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          args = { "--disable", "MD013", "--" },
        },
        sqlfluff = {
          args = {
            "lint",
            "--format=json",
            "--dialect=postgres",
            "--config",
          },
        },
      },
    },
  },
}
