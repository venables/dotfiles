return {
  {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "oled",
      highlight_overrides = {
        -- Make untracked git files brighter (default links to NonText which is same as hidden)
        SnacksPickerGitStatusUntracked = { fg = "#85b5ba" }, -- cyan from oldworld palette
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "oldworld",
    },
  },
}
