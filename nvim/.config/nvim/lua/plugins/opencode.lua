return {
  "NickvanDyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {},
  -- Lazy-load on these keymaps
  keys = {
    {
      "<C-a>",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask opencode",
    },
    {
      "<C-x>",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Execute opencode action",
    },
    {
      "ga",
      function()
        require("opencode").prompt("@this")
      end,
      mode = { "n", "x" },
      desc = "Add to opencode",
    },
    {
      "<C-.>",
      function()
        require("opencode").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle opencode",
    },
    {
      "<S-C-u>",
      function()
        require("opencode").command("session.half.page.up")
      end,
      desc = "opencode half page up",
    },
    {
      "<S-C-d>",
      function()
        require("opencode").command("session.half.page.down")
      end,
      desc = "opencode half page down",
    },
    -- Remap standard increment/decrement since we hijacked C-a/C-x
    { "+", "<C-a>", desc = "Increment", remap = true },
    { "-", "<C-x>", desc = "Decrement", remap = true },
  },
  config = function()
    vim.g.opencode_opts = {}

    vim.o.autoread = true
  end,
}
