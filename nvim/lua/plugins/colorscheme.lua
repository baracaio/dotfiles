return {
  "rebelot/kanagawa.nvim",
  priority = 1000, -- Ensures it loads before other plugins
  config = function()
    require("kanagawa").setup({
      compile = true, -- Set to true if you want precompiled styles for performance
      undercurl = true, -- Enable undercurl styling
      commentStyle = { italic = true },
      functionStyle = { italic = false },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = { italic = true },
      transparent = false, -- Set true if you want a transparent background
      dimInactive = true, -- Dim inactive windows
      terminalColors = true,
      colors = {
        theme = { all = { ui = { bg_gutter = "none" } } }, -- Remove background gutter
      },
      background = { -- Set Dragon variant
        dark = "dragon",
        light = "lotus",
      },
    })

    -- Apply the colorscheme
    vim.cmd("colorscheme kanagawa-dragon")
  end,
}
