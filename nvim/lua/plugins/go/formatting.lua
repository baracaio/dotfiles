-- Auto-formatting on save
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimports()
  end,
  group = format_sync_grp,
})

vim.keymap.set("n", "<leader>gfm", "<cmd>GoFmt<cr>", { desc = "Go Format" })
vim.keymap.set("n", "<leader>gfi", "<cmd>GoImports<cr>", { desc = "Go Imports" })
