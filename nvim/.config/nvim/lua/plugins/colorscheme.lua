return {
  -- add tokyonight
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
    },
  },

  -- Configure LazyVim to load tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
