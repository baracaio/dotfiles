return {
  "RRethy/vim-illuminate",
  event = "LazyFile",
  opts = {
    -- Providers: provider used to get references in the buffer, ordered by priority
    providers = {
      "lsp",
      "treesitter",
      "regex",
    },

    -- Delay in milliseconds
    delay = 100,

    -- Filetype blacklist
    filetypes_denylist = {
      "dirbuf",
      "dirvish",
      "fugitive",
      "alpha",
      "NvimTree",
      "lazy",
      "neogitstatus",
      "Trouble",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "TelescopePrompt",
    },

    -- Filetypes allowlist, only allow illumination for these filetypes
    -- (this is ignored if filetypes_denylist is set)
    filetypes_allowlist = {},

    -- Modes to illuminate, this can be a table like {n = true, v = true, i = false}
    -- or just a table of mode names like {"n", "v", "i"}
    modes_denylist = {},
    modes_allowlist = {},

    -- Providers allowlist, only use these providers
    -- (this is ignored if providers_denylist is set)
    providers_allowlist = {},

    -- Providers denylist, don't use these providers
    providers_denylist = {},

    -- Under-cursor illumination configuration
    under_cursor = true,

    -- Large file cutoff to disable illumination
    large_file_cutoff = nil,

    -- Large file overrides to only use regex when file is very large
    large_file_overrides = nil,

    -- Minimum number of matches required to illuminate
    min_count_to_highlight = 1,

    -- Should illumination be done for the word under cursor or the exact match
    -- including word boundaries
    case_insensitive_regex = false,
  },

  config = function(_, opts)
    require("illuminate").configure(opts)

    -- Custom keymaps for navigation
    local function map(key, dir, buffer)
      vim.keymap.set("n", key, function()
        require("illuminate")["goto_" .. dir .. "_reference"](false)
      end, {
        desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference",
        buffer = buffer,
      })
    end

    -- Global keymaps (will work in any buffer)
    map("]]", "next")
    map("[[", "prev")

    -- Alternative keymaps that some users prefer
    -- Uncomment these if you prefer different bindings
    -- map("<a-n>", "next")
    -- map("<a-p>", "prev")

    -- You can also add these keymaps to be buffer-local
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local buffer = vim.api.nvim_get_current_buf()
        -- Add buffer-local keymaps if needed
        -- map("]]", "next", buffer)
        -- map("[[", "prev", buffer)
      end,
    })

    -- Custom highlight groups (optional customization)
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "Visual" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "Visual" })
  end,

  keys = {
    { "]]", desc = "Next Reference" },
    { "[[", desc = "Prev Reference" },
  },
}
