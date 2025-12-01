return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      hidden = true,
      respect_gitignore = false,
    },
    picker = {
      hidden = true,
      formatters = {
        file = {
          filename_first = true,
        },
      },
      sources = {
        files = {
          hidden = true,
        },
      },
    },
  },
}
