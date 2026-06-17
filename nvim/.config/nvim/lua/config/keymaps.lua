local map = vim.keymap.set

-- Comment with Cmd-/ (native gc/gcc in nvim 0.10+)
map("n", "<D-/>", "gcc", { remap = true })
map("v", "<D-/>", "gc", { remap = true })

-- Save without running format autocmds
map("n", "<leader>W", "<cmd>noautocmd w<cr>", { desc = "Save (no format)" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Plugin keymaps (neo-tree, telescope) live in their own plugin specs.
