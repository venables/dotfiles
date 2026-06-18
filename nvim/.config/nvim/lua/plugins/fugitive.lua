-- Full git layer. Inline current-line blame stays with gitsigns; fugitive
-- adds status/staging/diffs, a full blame view, and GBrowse (open the current
-- line or selection on GitHub via vim-rhubarb).
return {
  "tpope/vim-fugitive",
  dependencies = { "tpope/vim-rhubarb" },
  cmd = { "Git", "G", "GBrowse", "Gdiffsplit", "Gread", "Gwrite" },
  keys = {
    { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
    { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame (full)" },
    { "<leader>gB", "<cmd>GBrowse<cr>", desc = "Open line on GitHub" },
    { "<leader>gB", ":GBrowse<cr>", mode = "x", desc = "Open selection on GitHub" },
    { "<leader>gY", "<cmd>GBrowse!<cr>", desc = "Copy GitHub permalink" },
    { "<leader>gY", ":GBrowse!<cr>", mode = "x", desc = "Copy GitHub permalink" },
  },
}
