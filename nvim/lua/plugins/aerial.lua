return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = {
    "AerialToggle",
    "AerialOpen",
    "AerialClose",
    "AerialNext",
    "AerialPrev",
    "AerialGo",
    "AerialInfo",
    "AerialNavToggle",
  },
  keys = {
    { "<leader>o", "<cmd>AerialToggle!<cr>", desc = "Aerial Toggle" },
    { "<leader>O", "<cmd>AerialNavToggle<cr>", desc = "Aerial Nav Toggle" },
    { "[s", "<cmd>AerialPrev<cr>", desc = "Aerial Prev Symbol" },
    { "]s", "<cmd>AerialNext<cr>", desc = "Aerial Next Symbol" },
  },

  opts = {
    -- Priority list of preferred backends for aerial
    backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

    -- Layout configuration
    layout = {
      -- Width settings (can be integer or float between 0-1)
      max_width = { 40, 0.25 }, -- Max 40 chars or 25% of screen
      width = nil, -- Use max_width instead
      min_width = 20, -- Minimum width

      -- Window options for aerial window
      win_opts = {
        winhl = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },

      -- Direction to open aerial window
      default_direction = "prefer_right",

      -- Placement: "edge" (far right/left) or "window" (next to current)
      placement = "window",

      -- Auto-resize window to fit content
      resize_to_content = true,

      -- Preserve window size equality
      preserve_equality = false,
    },

    -- How aerial decides which buffer to show symbols for
    attach_mode = "window", -- "window" or "global"

    -- Auto-close aerial when certain events happen
    close_automatic_events = { "unfocus" },

    -- Keymaps in aerial window
    keymaps = {
      ["?"] = "actions.show_help",
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.jump",
      ["<2-LeftMouse>"] = "actions.jump",
      ["<C-v>"] = "actions.jump_vsplit",
      ["<C-s>"] = "actions.jump_split",
      ["p"] = "actions.scroll",
      ["<C-j>"] = "actions.down_and_scroll",
      ["<C-k>"] = "actions.up_and_scroll",
      ["{"] = "actions.prev",
      ["}"] = "actions.next",
      ["[["] = "actions.prev_up",
      ["]]"] = "actions.next_up",
      ["q"] = "actions.close",
      ["o"] = "actions.tree_toggle",
      ["za"] = "actions.tree_toggle",
      ["O"] = "actions.tree_toggle_recursive",
      ["zA"] = "actions.tree_toggle_recursive",
      ["l"] = "actions.tree_open",
      ["zo"] = "actions.tree_open",
      ["L"] = "actions.tree_open_recursive",
      ["zO"] = "actions.tree_open_recursive",
      ["h"] = "actions.tree_close",
      ["zc"] = "actions.tree_close",
      ["H"] = "actions.tree_close_recursive",
      ["zC"] = "actions.tree_close_recursive",
      ["zr"] = "actions.tree_increase_fold_level",
      ["zR"] = "actions.tree_open_all",
      ["zm"] = "actions.tree_decrease_fold_level",
      ["zM"] = "actions.tree_close_all",
      ["zx"] = "actions.tree_sync_folds",
      ["zX"] = "actions.tree_sync_folds",
    },

    -- Don't load aerial until needed
    lazy_load = true,

    -- Performance limits
    disable_max_lines = 10000,
    disable_max_size = 2000000, -- 2MB

    -- Symbol filtering - which symbols to show
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
      "Variable",
      "Constant",
      "Field",
      "Property",
    },

    -- Highlighting options
    highlight_mode = "split_width", -- "split_width", "full_width", "last", "none"
    highlight_closest = true, -- Highlight closest symbol to cursor
    highlight_on_hover = false, -- Highlight symbol when hovering in aerial
    highlight_on_jump = 300, -- Flash duration when jumping (ms)

    -- Auto-jump to symbol when cursor moves
    autojump = false,

    -- Custom icons (uses nerd font icons by default)
    icons = {},

    -- Ignore certain windows/buffers
    ignore = {
      unlisted_buffers = false,
      diff_windows = true,
      filetypes = {},
      buftypes = "special",
      wintypes = "special",
    },

    -- Folding integration
    manage_folds = false, -- Use aerial for code folding
    link_folds_to_tree = false, -- Update tree when folding code
    link_tree_to_folds = true, -- Fold code when toggling tree

    -- Use nerd font icons
    nerd_font = "auto", -- true, false, or "auto"

    -- Callbacks
    on_attach = function(bufnr)
      -- Buffer-specific keymaps when aerial attaches
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Aerial Prev" })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Aerial Next" })
    end,

    on_first_symbols = function(bufnr)
      -- Called when symbols are first loaded for a buffer
    end,

    -- Don't auto-open aerial
    open_automatic = false,

    -- Command to run after jumping to symbol
    post_jump_cmd = "normal! zz",

    -- Filter/modify symbols
    post_parse_symbol = function(bufnr, item, ctx)
      -- Return false to filter out symbol
      return true
    end,

    -- Auto-close after selecting symbol
    close_on_select = false,

    -- Events that trigger symbol updates
    update_events = "TextChanged,InsertLeave",

    -- Show tree guides (lines connecting symbols)
    show_guides = true,

    -- Guide characters
    guides = {
      mid_item = "├─",
      last_item = "└─",
      nested_top = "│ ",
      whitespace = "  ",
    },

    -- Floating window configuration
    float = {
      border = "rounded",
      relative = "cursor", -- "cursor", "editor", "win"
      max_height = 0.9,
      height = nil,
      min_height = { 8, 0.1 },
      override = function(conf, source_winid)
        -- Customize floating window config
        return conf
      end,
    },

    -- Navigation window configuration
    nav = {
      border = "rounded",
      max_height = 0.9,
      min_height = { 10, 0.1 },
      max_width = 0.5,
      min_width = { 0.2, 20 },
      win_opts = {
        cursorline = true,
        winblend = 10,
      },
      autojump = false,
      preview = false, -- Show code preview
      keymaps = {
        ["<CR>"] = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["h"] = "actions.left",
        ["l"] = "actions.right",
        ["<C-c>"] = "actions.close",
      },
    },

    -- LSP backend configuration
    lsp = {
      diagnostics_trigger_update = false,
      update_when_errors = true,
      update_delay = 300,
      priority = {
        -- Customize LSP client priority
        -- pyright = 10,
      },
    },

    -- Treesitter backend configuration
    treesitter = {
      update_delay = 300,
    },

    -- Markdown backend configuration
    markdown = {
      update_delay = 300,
    },
  },

  config = function(_, opts)
    require("aerial").setup(opts)

    -- Additional keymaps
    vim.keymap.set("n", "<leader>oo", "<cmd>AerialToggle<cr>", { desc = "Aerial Toggle (Stay)" })
    vim.keymap.set("n", "<leader>of", "<cmd>AerialToggle float<cr>", { desc = "Aerial Float" })
    vim.keymap.set("n", "<leader>ol", "<cmd>AerialToggle left<cr>", { desc = "Aerial Left" })
    vim.keymap.set("n", "<leader>or", "<cmd>AerialToggle right<cr>", { desc = "Aerial Right" })

    -- Integration with existing telescope/fzf if available
    if pcall(require, "telescope") then
      vim.keymap.set("n", "<leader>os", "<cmd>Telescope aerial<cr>", { desc = "Aerial Symbols (Telescope)" })
    end

    -- Custom highlight groups (optional)
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Customize aerial highlights
        vim.api.nvim_set_hl(0, "AerialLine", { link = "CursorLine" })
        vim.api.nvim_set_hl(0, "AerialGuide", { link = "Comment" })
        -- Add more custom highlights as needed
      end,
    })
  end,
}
