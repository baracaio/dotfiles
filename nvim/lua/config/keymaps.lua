-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function close_all_folds()
  vim.api.nvim_exec2("%foldc!", { output = false })
end
local function open_all_folds()
  vim.api.nvim_exec2("%foldo!", { output = false })
end

vim.keymap.set("n", "<leader>zs", close_all_folds, { desc = "[s]hut all folds" })
vim.keymap.set("n", "<leader>zo", open_all_folds, { desc = "[o]pen all folds" })

vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false, desc = "exit insert mode" })
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false, desc = "exit insert mode" })

-- Center page after half-page movements
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })
