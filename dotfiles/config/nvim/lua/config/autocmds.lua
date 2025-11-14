-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always loaded: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-close vim if only file explorer is left open
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("auto_close_explorer", { clear = true }),
  callback = function()
    local wins = vim.api.nvim_list_wins()
    if #wins == 0 then return end
    
    -- Check if any window shows a non-explorer buffer
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.fn.buflisted(buf) == 1 then
        local buftype = vim.api.nvim_buf_get_option(buf, "filetype")
        -- If we find any non-explorer buffer, don't close
        if buftype ~= "neo-tree" and buftype ~= "netrw" and buftype ~= "NvimTree" and buftype ~= "oil" then
          return
        end
      end
    end
    
    -- All visible buffers are explorers, so close
    vim.defer_fn(function()
      vim.cmd("quit")
    end, 100)
  end,
})