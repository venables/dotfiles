return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false, -- neo-tree lazily loads itself
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer (toggle)" },
    { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Explorer (reveal file)" },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true, -- show filtered items dimmed rather than fully hiding
        hide_dotfiles = false, -- show .env, .gitignore, etc.
        hide_gitignored = false, -- show gitignored files like .env
        hide_by_name = {
          ".DS_Store",
          ".git",
          "node_modules",
          ".next",
          ".turbo",
          "__pycache__",
          ".venv",
          ".vercel",
        },
      },
    },
    window = {
      width = 32,
      mappings = {
        ["<space>"] = "none", -- keep leader free inside the tree
      },
    },
  },
}
