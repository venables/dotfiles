return {
  "saghen/blink.cmp",
  version = "1.*", -- use the prebuilt fuzzy binary (no Rust toolchain needed)
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    -- C-y accept, C-n/C-p select, C-space docs (built-in-completion style)
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "normal" }, -- matches the non-mono terminal font
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
