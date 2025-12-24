return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "oxfmt" },
      typescript = { "oxfmt" },
      javascriptreact = { "oxfmt" },
      typescriptreact = { "oxfmt" },
    },
    formatters = {
      oxfmt = {
        command = "oxlint",
        args = { "--fix", "$FILENAME" },
        stdin = false,
      },
    },
  },
}