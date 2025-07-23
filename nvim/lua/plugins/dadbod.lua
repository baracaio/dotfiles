return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Basic configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_help = 0 -- Hide help text
      vim.g.db_ui_winwidth = 40 -- Drawer width

      -- Save location for queries
      vim.g.db_ui_save_location = vim.fn.expand("~/.local/share/db_ui")

      -- Default query template
      vim.g.db_ui_default_query = 'select * from "{table}" limit 100'

      -- Auto execute table helpers
      vim.g.db_ui_auto_execute_table_helpers = 0

      -- Progress bar (disable if you want custom handling)
      vim.g.db_ui_disable_progress_bar = 0

      -- Icons configuration
      vim.g.db_ui_icons = {
        expanded = "▾",
        collapsed = "▸",
        saved_query = "*",
        new_query = "+",
        tables = "~",
        buffers = "»",
        connection_ok = "✓",
        connection_error = "✕",
      }

      -- Table helpers for different database types
      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = 'select count(*) from "{table}"',
          Explain = 'explain (analyze, buffers) select * from "{table}" limit 100',
          Describe = '\\d+ "{table}"',
        },
        mysql = {
          Count = "select count(*) from `{table}`",
          Explain = "explain select * from `{table}` limit 100",
          Describe = "describe `{table}`",
        },
        sqlite = {
          Count = 'select count(*) from "{table}"',
          Schema = '.schema "{table}"',
        },
      }

      -- Example database connections (REMOVE OR MODIFY THESE)
      -- You can configure connections in multiple ways:

      -- Method 1: Using g:dbs (configure your actual databases here)
      vim.g.dbs = {
        -- Example connections - MODIFY THESE TO YOUR ACTUAL DATABASES
        -- { name = "dev", url = "postgres://user:pass@localhost:5432/mydb" },
        -- { name = "staging", url = "postgres://user:pass@staging:5432/mydb" },
        -- { name = "local_sqlite", url = "sqlite:///path/to/database.db" },
        -- { name = "mysql_local", url = "mysql://root:password@localhost:3306/mydb" },
      }

      -- Method 2: Environment variables
      -- Set these in your shell:
      -- export DBUI_URL="postgres://user:pass@localhost:5432/mydb"
      -- export DBUI_NAME="my_connection"

      -- Method 3: .env file (requires tpope/vim-dotenv)
      -- Create a .env file with:
      -- DB_UI_DEV=postgres://user:pass@localhost:5432/dev_db
      -- DB_UI_PRODUCTION=postgres://user:pass@prod:5432/prod_db
    end,

    config = function()
      -- Custom keymaps for database operations
      vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<cr>", { desc = "Toggle Database UI" })
      vim.keymap.set("n", "<leader>dB", "<cmd>DBUI<cr>", { desc = "Open Database UI" })
      vim.keymap.set("n", "<leader>da", "<cmd>DBUIAddConnection<cr>", { desc = "Add Database Connection" })
      vim.keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", { desc = "Find Database Buffer" })

      -- SQL file specific keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "sql",
        callback = function()
          vim.keymap.set("n", "<leader>dw", "<Plug>(DBUI_SaveQuery)", { buffer = true, desc = "Save Query" })
          vim.keymap.set(
            "n",
            "<leader>de",
            "<Plug>(DBUI_EditBindParameters)",
            { buffer = true, desc = "Edit Bind Parameters" }
          )
          vim.keymap.set("n", "<leader>dr", "<cmd>w<cr>", { buffer = true, desc = "Execute Query (Write)" })
        end,
      })

      -- DBUI drawer specific keymaps (optional customizations)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dbui",
        callback = function()
          -- Override default mappings if needed
          -- vim.keymap.set("n", "v", "<Plug>(DBUI_SelectLineVsplit)", { buffer = true })
          -- vim.keymap.set("n", "s", "<Plug>(DBUI_SelectLine)", { buffer = true })
        end,
      })

      -- Auto-completion setup for SQL files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          -- Enable dadbod completion
          if pcall(require, "cmp") then
            require("cmp").setup.buffer({
              sources = {
                { name = "vim-dadbod-completion" },
                { name = "buffer" },
              },
            })
          end
        end,
      })
    end,
  },

  -- Optional: Add nvim-cmp source for dadbod completion
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "vim-dadbod-completion" })
    end,
  },
}
