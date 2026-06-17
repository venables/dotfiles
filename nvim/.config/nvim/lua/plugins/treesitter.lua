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

    local want = {
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
    }

    -- Only install parsers that are missing, so startup does no treesitter
    -- work once everything is present.
    local ts = require("nvim-treesitter")
    local installed = {}
    for _, p in ipairs(ts.get_installed("parsers")) do
      installed[p] = true
    end
    local missing = vim.tbl_filter(function(p)
      return not installed[p]
    end, want)
    if #missing > 0 then
      pcall(ts.install, missing)
    end

    -- Enable highlighting for any filetype that has a parser installed.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
