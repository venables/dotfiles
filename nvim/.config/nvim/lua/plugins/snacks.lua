return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      hidden = true,
      ignored = true,
    },
    picker = {
      hidden = true,
      ignored = true,
      formatters = {
        file = {
          filename_first = true,
        },
      },
      sources = {
        files = {
          hidden = true,
          ignored = false,
          include = { ".env*" },
        },
      },
    },
  },
}
