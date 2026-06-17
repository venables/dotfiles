local oxfmt = { "oxfmt" }

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    -- Format on save. Use :W / <leader>W (noautocmd w) to save without formatting.
    format_on_save = { timeout_ms = 3000, lsp_format = "never" },
    -- oxfmt is not a conform builtin; define it (reads stdin, infers parser from filename).
    formatters = {
      oxfmt = {
        command = "oxfmt",
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
      },
    },
    formatters_by_ft = {
      javascript = oxfmt,
      javascriptreact = oxfmt,
      typescript = oxfmt,
      typescriptreact = oxfmt,
      json = { "fixjson", "oxfmt" },
      jsonc = { "fixjson", "oxfmt" },
      json5 = { "fixjson", "oxfmt" },
      yaml = oxfmt,
      toml = oxfmt,
      html = oxfmt,
      vue = oxfmt,
      css = oxfmt,
      scss = oxfmt,
      less = oxfmt,
      markdown = { "oxfmt", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "oxfmt", "markdownlint-cli2", "markdown-toc" },
      graphql = oxfmt,
    },
  },
}
