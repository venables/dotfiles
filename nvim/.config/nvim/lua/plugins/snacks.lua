-- Minimal dashboard styled like Neovim's built-in intro (no big LazyVim banner).
-- Shows in the main pane while the explorer is open, like LazyVim's default.
local v = vim.version()
local header = table.concat({
  "",
  ("NVIM v%d.%d.%d"):format(v.major, v.minor, v.patch),
  "Nvim is open source and freely distributable",
  "https://neovim.io",
  "",
}, "\n")

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = { header = header },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
