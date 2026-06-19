-- Disable the snacks dashboard so Neovim shows its built-in start screen
return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
    },
  },
}
