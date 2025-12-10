return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      formatters = {
        file = {
          filename_first = true,
        },
      },
      sources = {
        files = {
          hidden = true,
          ignored = true,
          exclude = {
            "node_modules",
            ".git",
            ".turbo",
            ".next",
            ".nuxt",
            ".vercel",
            ".cache",
            "dist",
            "build",
            ".venv",
            "venv",
            "__pycache__",
            ".pytest_cache",
            "coverage",
            ".terraform",
          },
        },
        explorer = {
          hidden = true,
          ignored = true,
        },
      },
    },
  },
}
