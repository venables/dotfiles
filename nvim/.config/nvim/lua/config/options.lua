-- Loaded before lazy.nvim. Leader must be set before plugins map keys.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 4
opt.wrap = false
opt.splitright = true
opt.splitbelow = true

-- Tabs and indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Behaviour
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.confirm = true
opt.updatetime = 200
opt.timeoutlen = 300

-- Disable unused providers (suppresses healthcheck warnings)
vim.g.loaded_perl_provider = 0

-- Treat .env.* files as env, not sh
vim.filetype.add({
  pattern = {
    ["%.env%.[%-%w_.]+"] = "env",
  },
})

-- :W saves without running format autocmds
vim.api.nvim_create_user_command("W", "noautocmd w", {})
