return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
  },
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()',

  config = function()
    -- Import configurations
    local lsp_config = require("plugins.go.lsp")
    local diagnostic_config = require("plugins.go.diagnostics")

    -- Setup go.nvim with modular configs
    require("go").setup(vim.tbl_deep_extend("force", {
      -- Basic settings
      goimports = "gopls",
      gofmt = "gofumpt",
      test_runner = "go",
      verbose_tests = true,

      -- DAP settings
      dap_debug = true,
      dap_debug_keymap = false, -- We handle keymaps separately
      dap_debug_gui = false,
      dap_debug_vt = false,

      -- Icons
      icons = {
        breakpoint = "🔴",
        currentpos = "👉",
      },
    }, lsp_config, diagnostic_config))

    -- Load other modules
    require("plugins.go.formatting")
    require("plugins.go.keymaps")
    require("plugins.go.diagnostics").setup_keymaps()
  end,
}
