return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      markdown = { "markdownlint-cli2" },
    }

    lint.linters["markdownlint-cli2"].args = {
      "--config",
      vim.fn.expand("~/.markdownlint-cli2.jsonc"),
      "--",
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
