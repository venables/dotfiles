-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Tabs and indentation
opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while editing (default: 0)

-- Disable unused providers (suppresses healthcheck warnings)
vim.g.loaded_perl_provider = 0

-- Ensure dotenv files aren't treated as sh so bashls/shellcheck won't attach.
vim.filetype.add({
  filename = {
    [".env"] = "dotenv",
    [".env.local"] = "dotenv",
  },
  pattern = {
    [".*%.env%..*"] = "dotenv",
  },
})
