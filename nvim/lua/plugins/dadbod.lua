return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    "tpope/vim-dadbod", -- Database interface
    "tpope/vim-dotenv",
    lazy = true,
    "kristijanhusak/vim-dadbod-completion", -- Completion for SQL
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Set up dadbod UI options
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
    vim.g.db_ui_force_echo_notifications = 1
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_winwidth = 40

    vim.g.db_ui_dotenv_variable_prefix = "DB_UI_"

    vim.keymap.set(
      "n",
      "<leader>dbui",
      ":DBUIToggle<CR>",
      { noremap = true, silent = true, desc = "Toggle Database UI" }
    )

    -- Additional database related mappings
    vim.keymap.set(
      "n",
      "<leader>dbc",
      ":DBUIAddConnection<CR>",
      { noremap = true, silent = true, desc = "Add DB Connection" }
    )
    vim.keymap.set(
      "n",
      "<leader>dbf",
      ":DBUIFindBuffer<CR>",
      { noremap = true, silent = true, desc = "Find DB Buffer" }
    )
    vim.keymap.set(
      "n",
      "<leader>dbs",
      ":DBUIRenameBuffer<CR>",
      { noremap = true, silent = true, desc = "Rename DB Buffer" }
    )
    -- Set up autocomplete
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
      end,
    })
  end,
}
