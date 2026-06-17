return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000, -- load before other plugins so highlights are set early
  opts = {},
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
