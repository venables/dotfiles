return {
  "NickvanDyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {},
  -- Lazy-load on these keymaps
  keys = {
    -- Ask opencode about current file/selection with @this context, auto-submits
    {
      "<C-a>",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask opencode",
    },
    -- Open action picker to select from available opencode actions
    {
      "<C-x>",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Execute opencode action",
    },
    -- Add current file/selection to opencode prompt with @this context
    {
      "ga",
      function()
        require("opencode").prompt("@this")
      end,
      mode = { "n", "x" },
      desc = "Add to opencode",
    },
    -- Toggle the opencode window open/closed
    {
      "<C-.>",
      function()
        require("opencode").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle opencode",
    },
    -- Toggle opencode (leader mapping for AI menu)
    {
      "<leader>o",
      function()
        require("opencode").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle opencode",
    },
    -- Also add to LazyVim's AI menu (<leader>a prefix)
    {
      "<leader>ao",
      function()
        require("opencode").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle opencode",
    },
    {
      "<leader>aa",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask opencode",
    },
    {
      "<leader>as",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Select opencode action",
    },
    {
      "<leader>ap",
      function()
        require("opencode").prompt("@this")
      end,
      mode = { "n", "x" },
      desc = "Add to opencode prompt",
    },
    -- Scroll up in opencode session
    {
      "<S-C-u>",
      function()
        require("opencode").command("session.half.page.up")
      end,
      desc = "opencode half page up",
    },
    -- Scroll down in opencode session
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
