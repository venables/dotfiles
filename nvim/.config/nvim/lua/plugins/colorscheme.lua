return {
  {
    "folke/tokyonight.nvim",
    opts = {
      on_highlights = function(hl, c)
        -- Make untracked git files brighter (default links to NonText which is same as hidden)
        hl.SnacksPickerGitStatusUntracked = { fg = c.cyan }
        -- Make dot-prefix files visible (not dimmed like true hidden files)
        hl.SnacksPickerPathHidden = { fg = c.fg_dark }
      end,
    },
  },
}
