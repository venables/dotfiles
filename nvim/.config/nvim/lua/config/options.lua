-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Tabs and indentation
opt.softtabstop = 2 -- Number of spaces that a <Tab> counts for while editing (default: 0)

-- Disable unused providers (suppresses healthcheck warnings)
vim.g.loaded_perl_provider = 0

-- LazyVim's util.dot extra maps .env.* to sh (lazyvim/plugins/extras/util/dot.lua).
-- Use a different-but-equivalent pattern string so it doesn't clobber our entry
-- in the pattern table, then outrank it with priority.
vim.filetype.add({
  pattern = {
    ["%.env%.[%-%w_.]+"] = { "env", { priority = 100 } },
  },
})

-- Add :W for save-without-format
vim.api.nvim_create_user_command("W", "noautocmd w", {})
