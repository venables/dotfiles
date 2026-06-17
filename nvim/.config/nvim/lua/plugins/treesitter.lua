-- Use the `main` branch: the `master` branch is EOL and ships markdown
-- queries that crash Neovim 0.12's bundled treesitter ("range nil value").
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- treesitter does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    -- jsonc has no dedicated parser; reuse the json parser for it.
    vim.treesitter.language.register("json", "jsonc")

    pcall(require("nvim-treesitter").install, {
      "bash",
      "css",
      "dockerfile",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    })

    -- Enable highlighting for any filetype that has a parser installed.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
