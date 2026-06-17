return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Native fzf sorter (faster). Built with make; telescope still works if it fails.
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  keys = {
    { "<leader><space>", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find files" },
    { "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
  },
  opts = {
    defaults = {
      file_ignore_patterns = { "%.git/", "node_modules/" },
    },
    pickers = {
      find_files = {
        -- show hidden but not the .git dir; respect .gitignore noise via patterns above
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
  end,
}
