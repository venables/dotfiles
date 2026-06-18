return {
  "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
    "saghen/blink.cmp", -- load before attach so completion capability is advertised
  },
  opts = {
    ensure_installed = {
      "lua_ls",
      "vtsls", -- typescript / javascript
      "jsonls",
      "yamlls",
      "taplo", -- toml
      "marksman", -- markdown
      "terraformls",
      "dockerls",
      "docker_compose_language_service",
      "astro",
      "pyright", -- python
    },
  },
  config = function(_, opts)
    -- Advertise blink's completion capabilities to every server.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- lua_ls: know about the `vim` global when editing this config.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })

    -- ensure_installed + automatic_enable (calls vim.lsp.enable for each server).
    require("mason-lspconfig").setup(opts)

    -- Buffer-local keymaps once a server attaches.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
      callback = function(args)
        local builtin = require("telescope.builtin")
        local function map(keys, fn, desc, mode)
          vim.keymap.set(mode or "n", keys, fn, { buffer = args.buf, desc = "LSP: " .. desc })
        end
        map("gd", builtin.lsp_definitions, "Goto definition")
        map("gr", builtin.lsp_references, "References")
        map("gI", builtin.lsp_implementations, "Goto implementation")
        map("gy", builtin.lsp_type_definitions, "Type definition")
        map("K", vim.lsp.buf.hover, "Hover")
        map("<leader>cr", vim.lsp.buf.rename, "Rename")
        map("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
        map("<D-.>", vim.lsp.buf.code_action, "Code action")
      end,
    })

    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { desc = "Next diagnostic" })
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { desc = "Prev diagnostic" })
  end,
}
