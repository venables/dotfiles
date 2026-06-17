return {
  "nvim-mini/mini.surround",
  event = "VeryLazy",
  opts = {
    mappings = {
      add = "sa", -- add surrounding in normal and visual modes
      replace = "cs", -- change/replace surrounding
    },
  },
}
