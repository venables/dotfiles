local oxfmt = { "oxfmt" }

return {
  {
    "stevearc/conform.nvim",
    opts = {
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
  },
}
