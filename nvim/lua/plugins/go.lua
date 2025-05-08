return {
  "ray-x/go.nvim",
  dependencies = { -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("go").setup()

    -- fill commands
    vim.keymap.set("n", "<leader>Ger", "<CMD>:GoIfErr<CR>", { noremap = false, desc = "Go if error snippet" })
    vim.keymap.set("n", "<leader>Gpl", "<CMD>:GoFixPlurals<CR>", { noremap = false, desc = "Go fix plurals" })
    vim.keymap.set("n", "<leader>Gfs", "<CMD>:GoFilStruct<CR>", { noremap = false, desc = "Go fill structs" })
    vim.keymap.set("n", "<leader>Gfw", "<CMD>:GoFillSwitch<CR>", { noremap = false, desc = "Go fill switch" })

    -- test commands
    vim.keymap.set("n", "<leader>Gtt", "<CMD>:GoTestFile<CR>", { noremap = false, desc = "Go test current file" })
    vim.keymap.set("n", "<leader>Gtf", "<CMD>:GoTestFunc<CR>", { noremap = false, desc = "Go test nearest function" })
    vim.keymap.set("n", "<leader>Gtp", "<CMD>:GoTestPkg<CR>", { noremap = false, desc = "Go test current package" })
    vim.keymap.set("n", "<leader>Gcv", "<CMD>:GoCoverage<CR>", { noremap = false, desc = "Go generate test coverage" })
  end,
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
