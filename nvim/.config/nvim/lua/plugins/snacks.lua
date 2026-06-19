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
      -- Picker: show hidden files (essential in a dotfiles repo), exclude noise
      picker = {
        sources = {
          -- Explorer: show hidden + gitignored files (e.g. .env), minus common noise
          explorer = {
            hidden = true,
            ignored = true,
            exclude = {
              "__pycache__",
              ".cache",
              ".DS_Store",
              ".git",
              ".mypy_cache",
              ".next",
              ".pytest_cache",
              ".turbo",
              ".venv",
              ".vercel",
              "build",
              "coverage",
              "venv",
            },
          },
          files = {
            hidden = true,
            ignored = true,
            exclude = {
              "__pycache__",
              ".cache",
              ".DS_Store",
              ".git",
              ".mypy_cache",
              ".next",
              ".pytest_cache",
              ".turbo",
              ".venv",
              ".vercel",
              "build",
              "coverage",
              "dist",
              "node_modules",
              "venv",
            },
          },
          grep = {
            hidden = true,
            ignored = false, -- respect .gitignore for grep (don't search node_modules)
          },
        },
      },
    },
  },
}
